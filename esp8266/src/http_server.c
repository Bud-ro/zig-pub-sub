#include "ets_sys.h"

typedef signed char err_t;
typedef unsigned short u16_t;
typedef unsigned char u8_t;

struct tcp_pcb;
struct pbuf {
    struct pbuf *next;
    void *payload;
    u16_t tot_len;
    u16_t len;
    u8_t type;
    u8_t flags;
    u16_t ref;
    void *eb;
};

extern struct tcp_pcb *tcp_new(void);
extern err_t tcp_bind(struct tcp_pcb *pcb, void *ipaddr, u16_t port);
extern struct tcp_pcb *tcp_listen_with_backlog(struct tcp_pcb *pcb, u8_t backlog);
extern void tcp_accept(struct tcp_pcb *pcb, err_t (*accept)(void *, struct tcp_pcb *, err_t));
extern void tcp_recv(struct tcp_pcb *pcb, err_t (*recv)(void *, struct tcp_pcb *, struct pbuf *, err_t));
extern void tcp_err(struct tcp_pcb *pcb, void (*err)(void *, err_t));
extern void tcp_arg(struct tcp_pcb *pcb, void *arg);
extern err_t tcp_write(struct tcp_pcb *pcb, const void *data, u16_t len, u8_t flags);
extern err_t tcp_output(struct tcp_pcb *pcb);
extern err_t tcp_close(struct tcp_pcb *pcb);
extern void tcp_abort(struct tcp_pcb *pcb);
extern void tcp_recved(struct tcp_pcb *pcb, u16_t len);
extern u8_t pbuf_free(struct pbuf *p);
extern u16_t pbuf_copy_partial(struct pbuf *p, void *dataptr, u16_t len, u16_t offset);

extern unsigned int zig_http_handle(const char *request, unsigned int req_len,
                                     char *response, unsigned int resp_capacity);

static const char static_resp[] = "HTTP/1.1 200 OK\r\nConnection: close\r\n\r\n<h1>OK</h1>";
#define USE_STATIC_RESPONSE 1

static char response_buf[2048];
static volatile int active_conns = 0;

static void ICACHE_FLASH_ATTR http_err(void *arg, err_t err) {
    (void)arg;
    (void)err;
    if (active_conns > 0) active_conns--;
}

static err_t ICACHE_FLASH_ATTR http_sent(void *arg, struct tcp_pcb *pcb, u16_t len) {
    (void)arg;
    (void)len;
    tcp_abort(pcb);
    if (active_conns > 0) active_conns--;
    return -8; /* ERR_ABRT - pcb is gone */
}

static err_t ICACHE_FLASH_ATTR http_recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err) {
    (void)arg;

    if (p == 0 || err != 0) {
        if (p) pbuf_free(p);
        tcp_abort(pcb);
        if (active_conns > 0) active_conns--;
        return -8;
    }

    tcp_recved(pcb, p->tot_len);

    char req_buf[512];
    u16_t req_len = p->tot_len;
    if (req_len > 512) req_len = 512;
    pbuf_copy_partial(p, req_buf, req_len, 0);
    pbuf_free(p);

#if USE_STATIC_RESPONSE
    unsigned int resp_len = sizeof(static_resp) - 1;
    int si;
    for (si = 0; si < (int)resp_len; si++) response_buf[si] = static_resp[si];
#else
    unsigned int resp_len = zig_http_handle(req_buf, req_len, response_buf, sizeof(response_buf));
#endif

    if (resp_len > 0) {
        err_t werr = tcp_write(pcb, response_buf, (u16_t)resp_len, 1);
        if (werr == 0) {
            tcp_output(pcb);
            /* close after send completes via http_sent callback */
            return 0;
        }
    }

    /* write failed or no response - abort immediately */
    tcp_abort(pcb);
    if (active_conns > 0) active_conns--;
    return -8;
}

static err_t ICACHE_FLASH_ATTR http_accept(void *arg, struct tcp_pcb *pcb, err_t err) {
    (void)arg;
    (void)err;
    if (!pcb) return -8;

    if (active_conns >= 2) {
        tcp_abort(pcb);
        return -8;
    }
    active_conns++;

    tcp_arg(pcb, 0);
    tcp_recv(pcb, http_recv);
    tcp_err(pcb, http_err);
    tcp_sent(pcb, http_sent);
    return 0;
}

void ICACHE_FLASH_ATTR http_server_init_c(void) {
    struct tcp_pcb *pcb = tcp_new();
    if (!pcb) return;
    if (tcp_bind(pcb, 0, 80) != 0) return;
    struct tcp_pcb *lpcb = tcp_listen_with_backlog(pcb, 2);
    if (!lpcb) return;
    tcp_accept(lpcb, http_accept);
}
