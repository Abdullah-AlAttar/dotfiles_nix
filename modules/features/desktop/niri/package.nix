{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrapperModules.niriSettings];
    };
  };
}