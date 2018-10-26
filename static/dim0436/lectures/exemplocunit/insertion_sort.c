void insertionSort(int vetorDesordenado[], int tamanhoVetor )
{
   int i, j, valorAtual;
 
   for( j=1; j < tamanhoVetor; j++ ) 
   {
      valorAtual = vetorDesordenado[j];
      i = j-1;
      
      while(i >= 0 && vetorDesordenado[i] > valorAtual)
      {
        vetorDesordenado[i+1] = vetorDesordenado[i];
        i--;
      } 
              
      vetorDesordenado[i+1] = valorAtual;
   }
}