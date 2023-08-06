# Benchmarks

Ran on MacBook Pro (Retina, 15-inch, Mid 2015), 2.5 GHz Quad-Core Intel Core i7, 16 GB 1600 MHz DDR3

## Generating Payload

### 100k - 5 Depth

`Dir.glob`:

```
       user     system      total        real
Generate payload  0.775612   0.874461   1.650073 (  1.653699)
```

`Find.find`:
```
       user     system      total        real
Generate payload  1.142942   1.105188   2.248130 (  2.283416)
```

### 500k - 5 depth

`Dir.glob`:

```
        Dir.glob("**/*").select(&File.method(:file?)).each_with_object({}) do |file, memo|
          memo[file] = File.mtime(file).to_i
          memo
        end

       user     system      total        real
p  4.206203  21.714575  25.920778 ( 37.797033)
```

`Find.find`:
```
        Find.find(".").each_with_object({}) do |file, memo|
          memo[file] = File.mtime(file).to_i if File.file?(file)
          memo
        end

       user     system      total        real
p  5.881052  14.030111  19.911163 ( 26.033623)
```

### 500k - 5 depth - Parallel

`Dir.glob`:

```
      files = {}
      finish = Proc.new { |file, _, mtime| files[file] = mtime if mtime }
      Dir.chdir(path) do
        Parallel.each(Dir.glob("**/*").select(&File.method(:file?)), finish: finish) do |file, memo|
          File.mtime(file).to_i if File.file?(file)
        end
      end


       user     system      total        real
p 15.747701  25.826298  85.225837 ( 38.947283)
```

`Find.find`:
```
       user     system      total        real
p 16.490933  26.082348  86.025549 ( 40.376441)
```


## Sending files

### 1k

Parallel:

```
                user     system      total        real
Send files  0.377568   0.150736  11.477110 (  1.748968)
```


