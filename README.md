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

## Environment

- Ubuntu 22.04
- Docker (privileged container)
- bpftool, clang/llvm, libbpf

## Author

Chikkala Kiran Babu  
Ph.D. Student, Department of Computer Science and Engineering  
Indian Institute of Technology (IIT) Palakkad

## Instructor

Dr. Anish Hirwe  
Assistant Professor, IIT Palakkad
