using Pkg
Pkg.activate(".")
using Distributions
using FASTX
using CodecZlib




const pNums = Int[]

function getNum!(pNums, lbd, dst)
  if length(pNums) == 0 
    push!(pNums, (rand(dst, 10000) .+ 1)...)
  end
  pop!(pNums)
end

function makeDups(is, lbd; cMax=769200)
  c = 0
  dst = Poisson(lbd)
  readerR = FASTQReader(GzipDecompressorStream(open("../02readOverlap/ref1M.fa.IS$is.RW.fq.gz")))  
  
  writerL = FASTQWriter(GzipCompressorStream(open("ref1M.fa.IS$is.$lbd.FW.dup.fq.gz", "w")))
  writerR = FASTQWriter(GzipCompressorStream(open("ref1M.fa.IS$is.$lbd.RW.dup.fq.gz", "w")))
  
  FASTQReader(GzipDecompressorStream(open("../02readOverlap/ref1M.fa.IS$is.FW.fq.gz"))) do readerL
    for recordL in readerL
      recordR = first(readerR)
      for i in 1:getNum!(pNums, lbd, dst)
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
 
makeDups(300, 0.10)
makeDups(300, 0.25)
makeDups(300, 0.40)
makeDups(300, 0.55)
makeDups(300, 0.70)

makeDups(500, 0.10)
makeDups(500, 0.25)
makeDups(500, 0.40)
makeDups(500, 0.55)
makeDups(500, 0.70)


