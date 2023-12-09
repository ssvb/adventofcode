# Run benchmarks with a bunch of different compiler configurations

GDC=gdc-12.2.0
DMD=dmd-2.105.3
LDC=ldc2-1.35.0

dub -v build --build release --single --compiler=$LDC if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_ldc || exit 1
dub -v build --build release --single --compiler=$LDC --arch=x86 if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_ldc32 || exit 1
dub -v build --build release --single --compiler=$DMD if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_dmd || exit 1
dub -v build --build release --single --compiler=$DMD --arch=x86 if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_dmd32 || exit 1
dub -v build --build release --single --compiler=$GDC if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_gdc || exit 1
dub -v build --build release --single --compiler=$GDC --arch=x86 if_you_give_a_seed_a_fertilizer_mt_bruteforce.d && mv if_you_give_a_seed_a_fertilizer_mt_bruteforce fertilizer_dub_gdc32 || exit 1

echo "=== the initial $LDC warmup run (to be discarded) ==="
time ./fertilizer_dub_ldc < input.txt

echo "=== $LDC 64-bit ==="
time ./fertilizer_dub_ldc < input.txt
time ./fertilizer_dub_ldc < input.txt
time ./fertilizer_dub_ldc < input.txt

echo "=== $LDC 32-bit ==="
time ./fertilizer_dub_ldc32 < input.txt
time ./fertilizer_dub_ldc32 < input.txt
time ./fertilizer_dub_ldc32 < input.txt

echo "=== $DMD 64-bit ==="
time ./fertilizer_dub_dmd < input.txt
time ./fertilizer_dub_dmd < input.txt
time ./fertilizer_dub_dmd < input.txt

echo "=== $DMD 32-bit ==="
time ./fertilizer_dub_dmd32 < input.txt
time ./fertilizer_dub_dmd32 < input.txt
time ./fertilizer_dub_dmd32 < input.txt

echo "=== $GDC 64-bit ==="
time ./fertilizer_dub_gdc < input.txt
time ./fertilizer_dub_gdc < input.txt
time ./fertilizer_dub_gdc < input.txt

echo "=== $GDC 32-bit ==="
time ./fertilizer_dub_gdc32 < input.txt
time ./fertilizer_dub_gdc32 < input.txt
time ./fertilizer_dub_gdc32 < input.txt
