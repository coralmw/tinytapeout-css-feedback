for depth in (1, 10, 12, 15, 20, 25):
    for dim in ("x", "y", "z"):
        with open("LUTsynth.rkt.tmpl") as f:
            prog = f.read()
        prog = prog.replace("#DEPTH", str(depth))
        prog = prog.replace("#DIM", dim)
        with open(f"../build/{depth}-{dim}.rkt", "w") as f:
            f.write(prog)
            
