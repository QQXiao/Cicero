#!/bin/bash
#$ -S /bin/bash
#$ -N slope
#$ -cwd
#$ -j Y
#$ -V
#$ -m be
#$ -M water.read@gmail.com
#$ -q long.q
s=$1
scriptdir=/home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero/me/r_dir
R CMD BATCH $scriptdir/$s
