env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, "postgres://ohujkjsphlzsfl:RqUQR7BEyl2d3_GxJUTFc-eKmG@ec2-54-197-241-82.compute-1.amazonaws.com:5432/dfb13astcg6b47")

DataMapper.finalize
DataMapper.auto_upgrade!