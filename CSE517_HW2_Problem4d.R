p <- function(m,k,n){
  pvalues <- matrix(0,m,k)
  pvalues[,1] <- 0
  pvalues[1,] <- 1/(n^1:k)
  pvalues[1,1] <- 1
  if(m>1 & k>1){
    for(i in 2:m){
      for(j in 2:k){
        pvalues[i,j] <- (i/n)*pvalues[i,j-1] + ((n-i)/n)*pvalues[i-1,j-1]
      }
    }
  }
  return(pvalues[m,k])
}

expected <- function(n){
  expected_value = 0
  for(i in 1:n){
    expected_value = expected_value + (i/n)*p(i,n,n)
  }
  return(expected_value)
}

for(i in 1900:2000){
  print(expected(i))
}