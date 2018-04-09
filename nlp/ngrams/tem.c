#define NUMTHREADS 16
#define THREADWORK 1
#define ELEMINATED 10000

/* curVar is current variablle which we can find out by tx,ty,bx, by 
# that is 
# idx = blockIdx.x*blockDim.x+threadIdx.x
# idy = blockIdx.y*blockDim.y+threadIdx.y
# totx = blockDim.x*gridDim.y
# curVar = idx*(blockDim.)
# get all the mi that is globale 
# n is size of mi 
# rels is relevancy for current var with size n *n 
# reds is reudundencies for current var with size n *n size they are global
*/

__global__ void gpuMrnetb(float *mi, float *rels, float *reds, float *sums, float *res, size_t size)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    int totx = gridDim.x * blockDim.x;
    int curVar = idx * totx + idy;
    int temp;

    int k, i, worst, best;

    for (int i = 0; i < size; i++)
    {
        rels[curVar * size + i] = mi[curVar * size + i];
        reds[curVar * size + i] = sums[curVar * size + i] - mi[i * size + curVar];

        k++;
    }

    worst = 0;

    //select worst
    for (int i = 1; i < size; i++)
    {
        if ((rels[curVar * size + i] - reds[curVar * size + i] / k) < (rels[curVar * size + worst] - reds[curVar * size + worst] / k))
        {
            worst = i;
        }
    }

    best = worst;

    //backward elimination
    while ((k > 1) && ((rels[curVar * size + worst] - reds[curVar * size + worst] / k) < 0))
    {

        //eliminate worst
        rels[curVar * size + worst] = ELEMINATED;

        k--;

        for (int i = 0; i < size; i++)
        {
            reds[curVar * size + i] -= mi[i * size + worst];
        }
        worst = 0;

        for (int i = 1; i < size; i++)
        {

            if ((rels[curVar * size + i] - reds[curVar * size + i] / k) < (rels[curVar * size + worst] - reds[curVar * size + worst] / k))
                worst = i;
        }
    }

    //sequential replacement
    for (int i = 0; i < size; i++)
    {

        if (rels[curVar * size + i] == ELEMINATED)
        {
            if ((mi[curVar * size + i] - reds[curVar * size + i] / k) > (mi[curVar * size + best] - reds[curVar * size + best] / k))
                best = i;
        }
    }

    int ok = 1;
    while (ok)
    {
        rels[curVar * size + best] = mi[curVar * size + best];
        rels[curVar * size + worst] = ELEMINATED;

        for (int i = 0; i < size; i++)
            reds[curVar * size + i] += mi[i * size + best] - mi[i * size + worst];

        temp = best;
        best = worst;
        worst = temp;

        ok = 0;
        for (i = 0; i < size; i++)
        {
            if (rels[curVar * size + i] != ELEMINATED)
            {
                if ((rels[curVar * size + i] - reds[curVar * size + i] / k) < (rels[curVar * size + worst] - reds[curVar * size + worst] / k))
                {
                    worst = i;
                    ok = 1;
                }
            }
            else
            {
                if ((mi[curVar * size + i] - reds[i, curVar] / k) > (mi[curVar * size + best] - reds[curVar * size + best] / k))
                {
                    best = i;
                    ok = 1;
                }
            }
        }
    }

    for (i = 0; i < size; i++)
    {
        if (rels[curVar * size + i] == ELEMINATED)
            res[curVar * size + i] = 0;
        else
            res[curVar * size + i] = rels[curVar * size + i] - reds[curVar * size + i] / k;
    }
}