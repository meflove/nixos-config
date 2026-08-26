{
  perSystem = {inputs', ...}: {
    packages.angeldust-nvimWrap = inputs'.angeldust-nvimWrap.packages.default;
  };
}
