#include <stdio.h>
#include <string.h>
#include <CUnit/Basic.h>

int init_suite1(void)
{
  return 0;
  
}

int clean_suite1(void)
{
   return 0;
}

void testInsertionSort(void)
{
  int ateste[5] = {5,8,3,0,1};
  int acerto[5] = {0,1,3,5,8};
  
  insertionSort(ateste,5);
  
  int i;
  
  for(i=0; i < 5 ; i++){
    CU_ASSERT_EQUAL(acerto[i],ateste[i])
  }
}

/* The main() function for setting up and running the tests.
 * Returns a CUE_SUCCESS on successful running, another
 * CUnit error code on failure.
 */
int main()
{
   CU_pSuite pSuite = NULL;
   
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();
   
   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", init_suite1, clean_suite1);
   if (NULL == pSuite) {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* add the tests to the suite */
   /* NOTE - ORDER IS IMPORTANT - MUST TEST fread() AFTER fprintf() */
   if (NULL == CU_add_test(pSuite, "test of insertionSort()", testInsertionSort)
      )

   /* Run all tests using the CUnit Basic interface */
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   return CU_get_error();
}