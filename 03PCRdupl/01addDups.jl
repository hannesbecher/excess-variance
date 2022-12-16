using Pkg
Pkg.activate(".")
using Distributions
using FASTX
using CodecZlib

const lbd = 0.4
dst = Poisson(lbd)

const pNums = rand(dst, 10000) .+ 1

function getNum!(pNums)
  if length(pNums) == 0 
    push!(pNums, (rand(dst, 10000) .+ 1)...)
  end
  pop!(pNums)
end

function makeDups(cMax=769200)
  c = 0
  
  readerR = FASTQReader(GzipDecompressorStream(open("../02readOverlap/ref1M.fa.IS300.RW.fq.gz")))  
  
  writerL = FASTQWriter(GzipCompressorStream(open("../02readOverlap/ref1M.fa.IS300.FW.dup.fq.gz", "w")))
  writerR = FASTQWriter(GzipCompressorStream(open("../02readOverlap/ref1M.fa.IS300.RW.dup.fq.gz", "w")))
  
  FASTQReader(GzipDecompressorStream(open("../02readOverlap/ref1M.fa.IS300.FW.fq.gz"))) do readerL
    for recordL in readerL
      recordR = first(readerR)
      for i in 1:getNum!(pNums)
        if c == cMax break end
        write(writerL, recordL)
        write(writerR, recordR)
        c += 1
      end # poisson loop
      
    end #read loop
  end # do
  close(readerR)
  close(writerR)
  close(writerL)
end # function
 
makeDups()


