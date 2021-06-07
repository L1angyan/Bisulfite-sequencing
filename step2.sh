# bismark --genome ~/PATH/to/GRCh38/ -1 read1.fastq.gz -2 read2.fastq.gz -p 4 -o ./ 2>test.log
# for pair-end data. Here, authors apply single-end test data in FASTQ format.

bsub -J fastqc -n 16 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 \
"bismark --genome ~/ly/protocol/bs-seq/ref-genome test_data.fastq -p 4 -o ./"
# -p the number of thread.
# Notably, based on the different method of constructing sequencing library, different parameters would be used.
# If the "C -> U" transform is before constructing sequencing library, --non_directional parameter should be used.
# If the "C -> U" transform is after constructing sequencing library, just using default parameters.
# BS-seq有两种建库方式：1.先建好测序文库，然后用亚硫酸氢盐转化碱基，这种建库方式用默认参数
# 第二种建库方式：先对DNA进行亚硫酸氢盐处理，然后再对DNA进行文库构建，这种方法用--non_directional参数进行比对
# https://zhuanlan.zhihu.com/p/163495878
# 这里，作者给的以第一种方式建库的单端数据，因此用默认参数即可。

samtools view -b test_data_bismark_bt2.sam > test_data_bismark_bt2.bam
# 得到一个sam文件，其中为比对结果将其转为bam格式
# test_data_bismark_bt2_SE_report.txt为比对输出的另一个文件，包含比对信息和找到的各类型甲基化位点的信息。
deduplicate_bismark --bam test_data_bismark_bt2.bam
# 去除建库过程引入PCR重复，注意RRBS（一种通过酶切富集CpG区域的甲基化文库制备方法）不用去重

bsub -J fastqc -n 2 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 \
"bismark_methylation_extractor -no_header -s --gzip --bedGraph \
--buffer_size 5G -parallel 2  --cytosine_report --comprehensive \
--genome_folder ~/ly/protocol/bs-seq/ref-genome \
test_data_bismark_bt2.deduplicated.bam 2>extracor.log"
# 禁止在输出文件中输出软件版本头文件
# -s单端，-p双端
# --bedGraph输出一个.bedGraph和.cov文件，其中包括了甲基化位点位置、甲基化程度、reads数等等
# --cytosine_report输出一个网页
# --comprehensive汇总所有的甲基化类型
# --genome_folder基因组所在目录


# 至此，我们已经得到了甲基化位点的信息，如果有多个样品可以用其他软件包寻找差异甲基化区间/位点 (differentially methylation region/loci, DMR/DML)
