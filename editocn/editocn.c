#include <netcdf.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int fh;
    int vh1;
    int vh2;
    int len;
    int ndims;
    char *fname;
    char vname[20];
    int dimids[2];
    int nvars;
    int err;
    int *did;
    int cnt;
    int *mask;
    float *var;
    int nlon = 320;
    int nlat = 384;
    size_t vsize;
    size_t ds;
    int i;
    int j;
    char history[256];
    time_t ct;

    if(argc < 2){
        printf("Requires file name\n");
        exit -1;
    }

    len = strlen(argv[1]);
    fname = malloc(sizeof(char)*(len+1));
    strcpy(fname, argv[1]);
//    printf("Fname = %s %d\n",fname,len);

    err = nc_open(fname, NC_WRITE, &fh);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    err = nc_inq(fh, NULL, &nvars, NULL, NULL);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
    vh2 = nvars - 1;

    err = nc_inq_varid(fh, "REGION_MASK", &vh1);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    if(err == NC_ENOTVAR){
        printf("%s does not have REGION_MASK\n",fname);
        exit (0);
    }


    err = nc_inq_varname(fh, vh2, vname);

    err = nc_redef(fh);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
    ct = time(NULL);
    sprintf(history,"Modified to correct REGION_MASK and %s Fillvalues on %s",vname,ctime(&ct));

    err = nc_put_att_text(fh, NC_GLOBAL, "history", strlen(history) , history);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    err = nc_enddef(fh);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);


    err = nc_inq_vardimid(fh, vh1, &(dimids[i]));
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    err = nc_inq_varndims(fh, vh2, &ndims);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
    cnt = 0;
    vsize = 1;
//    printf("ndims is %d\n",ndims);
    did = malloc(sizeof(int)*ndims);

    err = nc_inq_vardimid(fh, vh2, did);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    for(i=0;i<ndims;i++){
        err = nc_inq_dimlen(fh, did[i], &ds);
        if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

        vsize *= ds;
        for(j=0; j<2; j++){
//            printf("did[%d]=%d dimids[%d]=%d\n",i,did[i],j,dimids[j]);
            if(did[i] == dimids[j])
                cnt++;
        }
    }
//    printf("cnt is %d vsize %ld\n",cnt, vsize);
    mask = malloc(sizeof(int) * nlon*nlat);
    err = nc_get_var(fh, vh1, mask);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
    if(cnt == 2){

//        printf("vsize = %ld\n",vsize);
        var = malloc(sizeof(float) * vsize);
        err = nc_get_var(fh, vh2, var);
        if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
        for(i=0;i<vsize;i++){
            j = i % (nlon*nlat);
            if(mask[j] == NC_FILL_INT){
                var[i] = NC_FILL_FLOAT;
            }else if(var[i] == (float) -1){
//                var[i] = NC_FILL_FLOAT;
                printf("%d %d %d\n",i,j,mask[j]);
            }

        }
        err = nc_put_var(fh, vh2, var);
        if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

        free(var);
    }
    for(i=0;i<nlon*nlat;i++){
        if(mask[i] == NC_FILL_INT){
            mask[i] = 0;
        }
    }
    err = nc_put_var(fh, vh1, mask);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);

    err = nc_close(fh);
    if(err) printf("%s %d %d\n",__FILE__,__LINE__,err);
    free(fname);
    free(mask);

}
