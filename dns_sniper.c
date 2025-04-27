#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("tracepoint/skb/consume_skb")
int trace_consume_skb(struct trace_event_raw_consume_skb *ctx)
{
    bpf_trace_printk("consume_skb: skbaddr=%lx\n", ctx->skbaddr);
    return 0;
}

char _license[] SEC("license") = "GPL";
