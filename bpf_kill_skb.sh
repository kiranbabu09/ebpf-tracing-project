#!/bin/bash

# Script to find and remove rogue eBPF programs attached to consume_skb tracepoint

echo "[*] Checking for pinned BPF programs..."

# List all pinned BPF programs in /sys/fs/bpf/
pinned_progs=$(find /sys/fs/bpf/ -type f)

for prog in $pinned_progs; do
    # Check if this pinned program is attached to skb:consume_skb
    bpftool prog show pinned $prog | grep -q "consume_skb"
    if [ $? -eq 0 ]; then
        echo "[+] Found suspicious program: $prog"
        echo "[+] Detaching and deleting..."

        # Try to detach (safe to ignore errors if already detached)
        bpftool prog detach pinned $prog tracepoint skb consume_skb 2>/dev/null

        # Delete the pinned program
        rm -f "$prog"
        
        echo "[+] Program $prog removed."
    fi
done

echo "[*] Checking in-memory BPF programs..."

# Now check all BPF programs (not only pinned ones)
ids=$(bpftool prog show | grep "consume_skb" | awk '{print $1}' | sed 's/://')

for id in $ids; do
    echo "[+] Deleting in-memory program ID: $id"
    bpftool prog delete id $id
done

echo "[✓] Mitigation completed."

