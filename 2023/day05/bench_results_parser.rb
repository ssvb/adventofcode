tmp = {}

def parse_time(s)
  if s =~ /\s*([0-9]+)m\s*([0-9\.]+)s/
    return $1.to_f * 60 + $2.to_f
  end
end

while s = gets
  if s =~ /=== (.*) ===/
    compiler = $1
  end
  if s =~ /real\s+(\S+)/
    time = $1
    tmp[compiler] = [] unless tmp.has_key?(compiler)
    tmp[compiler] << parse_time(time)
  end
end

tmp = tmp.to_a.sort {|a, b| a[1].min <=> b[1].min }.reverse

reftime = tmp[0][1].min
baseline_done = false

tbl = []
tbl.push(["compiler", "time", "speedup"])

tmp.each do |x|
  tbl.push([x[0].to_s, sprintf("%.1fs", x[1].min), sprintf("%.2fx faster", reftime / x[1].min)])
end

tbl[1][2] = "baseline"

widths = tbl.transpose.map {|x| x.map {|x| x.size}.max }
padding = widths.map {|x| "-" * x }
format = "| " + widths.map {|x| "%#{x}s" }.join(" | ") + " |\n"

tbl.insert(1, padding)

tbl.each {|x| printf(format, *x) }
