// TITLE: ArraySize calculation
// KEYWORK: arraysize

#include <iostream>
#include <cstddef>

// Nice arraysize calculation found in an article about the Chromium
// project.
// \see http://software.intel.com/en-us/articles/pvs-studio-vs-chromium
// \see http://codesearch.google.com/codesearch/p?hl=en#OAMlx_jo-ck/src/base/basictypes.h&q=arraysize&exact_package=chromium
template <typename T, size_t N> 
char (&ArraySizeHelper(T (&array)[N]))[N];
#define arraysize(array) (sizeof(ArraySizeHelper(array)))

// When an anonymous structure array is used for example.
#define ARRAYSIZE_UNSAFE(a)				\
  ((sizeof(a) / sizeof(*(a))) /				\
   static_cast<size_t>(!(sizeof(a) % sizeof(*(a)))))


int main(int ac, char **av)
{
  char	a[4];
  int	b[6];

  std::cout << arraysize(a) << std::endl; // 4
  std::cout << arraysize(b) << std::endl; // 6

  //  std::cout << sizeof(av) << std::endl;	=> compile
  //  std::cout << arraysize(av) << std::endl;	=> error a la compile
}
