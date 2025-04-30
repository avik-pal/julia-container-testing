using PackageCompiler

# Add your favorite packages here and they will be put into the sysimage
create_sysimage(
    [
        "Lux",
        "Reactant"
    ];
    sysimage_path="HiFlightSysImage.so",
    cpu_target="generic",
    sysimage_build_args=`-O3`
)
