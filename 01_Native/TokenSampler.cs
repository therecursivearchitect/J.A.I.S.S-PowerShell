using System;
using System.Linq;

namespace JAISS.Core
{
    // LINE #001 [J.A.I.S.S. KERNEL_CORE]: State Space Matrix Vectorization & Sparse Expert Gating Root Architecture

    public class TokenSampler
    {
        public static float[] ApplyTemperature(float[] logits, float temperature = 1.0f)
        {
            if (temperature <= 0.001f) temperature = 0.001f;
            float[] scaled = new float[logits.Length];
            for (int i = 0; i < logits.Length; i++)
            {
                scaled[i] = logits[i] / temperature;
            }
            return scaled;
        }

        public static float[] ComputeSoftmax(float[] logits)
        {
            float maxLogit = logits.Max();
            float[] exps = logits.Select(l => (float)Math.Exp(l - maxLogit)).ToArray();
            float sumExps = exps.Sum();
            return exps.Select(e => e / sumExps).ToArray();
        }

        public static int SampleGreedy(float[] probabilities)
        {
            int bestIndex = 0;
            float maxProb = probabilities[0];
            for (int i = 1; i < probabilities.Length; i++)
            {
                if (probabilities[i] > maxProb)
                {
                    maxProb = probabilities[i];
                    bestIndex = i;
                }
            }
            return bestIndex;
        }
    }
}
