# Discrete Exterior Calculus 2D

An implementation of [Discrete Exterior
Calculus](https://en.wikipedia.org/wiki/Discrete_exterior_calculus) for 2D
general (almost, see known issues) triangulations.

It is based on the explicative article published by [Rafael Herrera et
al.](https://www.scipedia.com/public/Herrera_et_al_2018b) about the use of DEC
as an alternative tool to solve numerical problems where [Finite Element
Methods](https://en.wikipedia.org/wiki/Finite_element_method) is used.

## Examples

You can found the project that inspired this implementation under
[examples](/examples).

### Known issues

It is to my knowledge that if in the triangulation there are two obtuse
triangles together and with the longest side shared, then the direction of the
dual edge will be inverted, giving an inverted sign length. However it should
not be hard to fix it, pull request welcome!

---

© 2020 José Joaquín Zubieta Rico

