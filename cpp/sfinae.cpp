// TITLE: Substitution failure is not an error
// KEYWORD: sfinae reflexivite template

#include <iostream>
 
template <typename T>
struct has_typedef_foobar {
  // Variables "yes" and "no" are guaranteed to have different sizes,
  // specifically sizeof(yes) == 1 and sizeof(no) == 2.
  typedef char yes[1];
  typedef char no[2];
 
  template <typename C>
  static yes& test(typename C::foobar*);
 
  template <typename>
  static no& test(...);
 
  // If the "sizeof" the result of calling test<T>(0) would be equal to the sizeof(yes),
  // the first overload worked and T has a nested type named type.
  static const bool value = sizeof(test<T>(0)) == sizeof(yes);
};
 
struct foo {    
  typedef float foobar;
};
 
int main() {
  std::cout << std::boolalpha;
  std::cout << has_typedef_foobar<int>::value << std::endl;
  std::cout << has_typedef_foobar<foo>::value << std::endl;
}
