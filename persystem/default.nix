{
  perSystem = {inputs', ...}: {
    packages.angeldust-nixCats = inputs'.angeldust-nixCats.packages.default;
    packages.angeldust-nviwWrap = inputs'.angeldust-nviwWrap.packages.default;
  };
}
