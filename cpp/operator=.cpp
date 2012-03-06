// TITLE operator=, const& ...
// keywork std::swap operator=

#include <algorithm>
#include <vector>

class toto {
  std::vector<int>	vec_;
public:
  virtual ~toto() {}

  toto() {}
  toto(const &toto);

  // http://en.wikibooks.org/wiki/More_C++_Idioms/Copy-and-swap
  // Also c++ reference for std::swap():
  // Because this function template is used as a primitive operation by
  // many other algorithms, it is highly recommended that large data
  // types overload their own specialization of this function. Notably,
  // all STL containers define such specializations (at least for the
  // standard allocator), in such a way that instead of swapping theirx
  // entire data content, only the values of a few internal pointers are
  // swapped, making this operation to operate in real constant time       
  // with them. 
  toto & operator=(toto other) {
    std::sawp(this->vec_, other.vec_);
  }

};
