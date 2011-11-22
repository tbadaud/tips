// TITLE: member static and class template
// KEYWORD: class member static template Too Few Template Parameter Lists
// LINK: http://c2.com/cgi/wiki?TooFewTemplateParameterLists

template <class T>
class A {
  static int a;
  static const char * const name;
};

// int A<int>::a = 0; This now fails with "error: too few template-parameter-lists"
// This conforms to the CeePlusPlus standard, which older versions of the compiler do not enforce.
template<> int A<int>::a = 0;
template<> const char * const  A<int>::name = "example";

int main()
{
  return 0;
}
