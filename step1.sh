conda create -n bs-seq
conda activate bs-seq
conda install bismark
conda install bowtie2
# install bismark software and bowtie2

wget http://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz
gunzip Homo_sapiens.GRCh38.dna.toplevel.fa.gz
# download reference genome

bismark_genome_preparation --path_to_aligner ~/miniconda3/envs/bs-seq/bin/ \
--verbose ~/ly/protocol/bs-seq/ref-genome/
# construct mapping index for BS-seq data
# 文库构建过程中，被甲基化的C不变，而未被甲基化的C变成了U
# 那么PCR扩增后，被甲基化的C变成了T，与C互补配对的G变成了A
# bismark将参考基因组中的C和G分别转换为T和A，分别建索引用于比对
tree ./ref-genome
# 查看目录结构

wget https://www.bioinformatics.babraham.ac.uk/projects/bismark/test_data.fastq
# download test data applied by authors
module load FastQC/0.11.5-Java-1.8.0_92
bsub -J fastqc -n 2 -R span[hosts=1] -o %J.out -e %J.err -q q2680v2 \
"fastqc test_data.fastq -o ./ -t 2"
# quality control,很干净不用切了
# module load fastp/0.20.0
