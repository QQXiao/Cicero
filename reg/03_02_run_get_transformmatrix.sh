for ((sub=14; sub<=31; sub++))
#for sub in 26
    #for sub in 1 2 3 4 5 6 7 8
    #1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
  #fsl_sub bash get_trans_matrix_h2e.sh $sub
  #fsl_sub bash get_trans_matrix_t2h.sh $sub
  #fsl_sub -q veryshort.q bash get_trans_matrix_e2h.sh $sub
  fsl_sub -q veryshort.q bash get_trans_matrix_h2t.sh $sub
  #fsl_sub -q verylong.q bash get_trans_matrix_n2e.sh $sub
done
