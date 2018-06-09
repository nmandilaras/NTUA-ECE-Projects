public class MyQuickSort {
     
    private int[][] array;
    private float b[];
    
    public void sort(int[][] inputArr, float[] inputBarr, int n ) {
         
        this.array = inputArr;
        this.b = inputBarr;
        quickSort(0, n - 1);
    }
 
    private void quickSort(int lowerIndex, int higherIndex) {
         
        int i = lowerIndex;
        int j = higherIndex;
        // calculate pivot number, I am taking pivot as middle index number
        int pivot = array[lowerIndex+(higherIndex-lowerIndex)/2][1];
        // Divide into two arrays
        while (i <= j) {
            /**
             * In each iteration, we will identify a number from left side which
             * is greater then the pivot value, and also we will identify a number
             * from right side which is less then the pivot value. Once the search
             * is done, then we exchange both numbers.
             */
            while (array[i][1] < pivot) {
                i++;
            }
            while (array[j][1] > pivot) {
                j--;
            }
            if (i <= j) {
                exchangeNumbers(i, j);
                //move index to next position on both sides
                i++;
                j--;
            }
        }
        // call quickSort() method recursively
        if (lowerIndex < j)
            quickSort(lowerIndex, j);
        if (i < higherIndex)
            quickSort(i, higherIndex);
    }
 
    private void exchangeNumbers(int i, int j) {
        int tmp;
        float pros;
         for(int k=0; k<4; k++){
             tmp = array[i][k];
             array[i][k] = array[j][k];
             array[j][k] = tmp;
            }
            pros=b[i];
            b[i]=b[j];
            b[j]=pros;        
    }
}