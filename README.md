# eBPF Tracing Attack and Mitigation Using consume_skb Tracepoint

## Overview
This project demonstrates how eBPF programs can be used to trace kernel events and how privileged containers can misuse tracepoints like `skb:consume_skb`. It also proposes a mitigation strategy using automated detection and removal of suspicious programs.

## Files

- `dns_sniper.c` : eBPF program attached to `skb:consume_skb`.
- `bpf_kill_skb.sh` : Mitigation script to find and remove suspicious eBPF programs.
- `trace_output.txt` : Example output captured from `/sys/kernel/tracing/trace_pipe`.

## Setup Instructions

1. Compile the eBPF program:

    ```bash
    clang -O2 -g -target bpf -c dns_sniper.c -o dns_sniper.o
    ```

2. Load and attach the program:

    ```bash
    bpftool prog load dns_sniper.o /sys/fs/bpf/dns_sniper type tracepoint
    bpftool prog attach pinned /sys/fs/bpf/dns_sniper tracepoint skb consume_skb
    ```

3. View tracing output:

    ```bash
    sudo cat /sys/kernel/tracing/trace_pipe
    ```

4. Mitigate and remove the rogue program:

    ```bash
    sudo ./bpf_kill_skb.sh
    ```
## Mitigation Details

The mitigation script `bpf_kill_skb.sh` works as follows:

1. It searches for all pinned and in-memory eBPF programs that are attached to the `skb:consume_skb` tracepoint.
2. It detaches the program from the tracepoint if it is still attached.
3. It deletes the pinned object from `/sys/fs/bpf/`.
4. It deletes any in-memory rogue eBPF programs by ID using `bpftool`.

### Before Running Mitigation

When we run:

```bash
bpftool prog show

You will see output like:

ID 42  TAG abc123def456...  Type tracepoint  Name trace_consume_skb
loaded_at 2025-04-27T10:00:00+0000  uid 0
pinned /sys/fs/bpf/dns_sniper

After Running Mitigation

After executing:

sudo ./bpf_kill_skb.sh

When we run:

bpftool prog show

You will see:

(No programs attached to tracepoint)

✅ This confirms that the malicious eBPF program has been detached and removed from the kernel.

Thus, the system becomes clean from rogue eBPF activity.

## Environment

- Ubuntu 22.04
- Docker (privileged container)
- bpftool, clang/llvm, libbpf

## Instructor

Dr. Anish Hirwe  
Assistant Professor, IIT Palakkad

## Author

Chikkala Kiran Babu  
Ph.D. Student, Department of Computer Science and Engineering  
Indian Institute of Technology (IIT) Palakkad
