using NetCDF,NCDatasets,ZfpCompression,BSON,Statistics

#Decompression function
function decompress_netcdf(comp_file)
    #Change the filename
    output = "test1.nc"

    #Gloabla Attributes
    attribs = BSON.load(comp_file)[:global_att]
    nccreate(output, "global", atts=attribs, mode=NC_NETCDF4)

    data = BSON.load(comp_file)
    varname = keys(data[:variables])
    for var in varname
        dims = data[:variables][var][:dims]
        dimlen = data[:variables][var][:dimlen]
        if size(dims)[1] == 3
            vardata = zfp_decompress(data[:variables][var][:data])
            nccreate(output, var, dims[1], dimlen[1], dims[2], dimlen[2], dims[3], dimlen[3], 
                atts=data[:variables][var][:atts],
                t=NC_FLOAT)
        elseif size(dims)[1] == 4
            vardata = zfp_decompress(data[:variables][var][:data])
            nccreate(output, var, dims[1], dimlen[1], dims[2], dimlen[2], dims[3], dimlen[3], dims[4], dimlen[4], 
            atts=data[:variables][var][:atts],
            t=NC_FLOAT)

        end
        ncwrite(vardata,output,var)

    end
end
