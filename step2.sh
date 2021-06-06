# bismark --genome ~/PATH/to/GRCh38/ -1 read1.fastq.gz -2 read2.fastq.gz -p 4 -o ./ 2>test.log
# for pair-end data. Here, authors apply single-end test data in FASTQ format.

bsub -J fastqc -n 4 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 \
"bismark --genome ~/ly/protocol/bs-seq/ref-genome test_data.fastq -p 4 -o ./"
# -p the number of thread.
# Notably, based on the different method of constructing sequencing library, different parameters would be used.
# If the "C -> U" transform is before constructing sequencing library, --non_directional parameter should be used.
# If the "C -> U" transform is after constructing sequencing library, just using default parameters.
# BS-seq有两种建库方式：1.先建好测序文库，然后用亚硫酸氢盐转化碱基，这种建库方式用默认参数
# 第二种建库方式：先对DNA进行亚硫酸氢盐处理，然后再对DNA进行文库构建，这种方法用--non_directional参数进行比对
# 这里，作者给的以第一种方式建库的单端数据，因此用默认参数即可。
