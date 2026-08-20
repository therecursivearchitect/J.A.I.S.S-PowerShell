using System;

namespace JAISS.Core
{
    public class SparseRouter
    {
        private readonly int _numExperts;
        private readonly int _topK;

        public SparseRouter(int numExperts, int topK = 2)
        {
            _numExperts = numExperts;
            _topK = topK;
        }

        public int[] RouteExpertGating(float[] logits)
        {
            if (logits.Length != _numExperts)
                throw new ArgumentException("Logits length must match total experts count.");

            int[] selectedExperts = new int[_topK];
            float[] tempLogits = (float[])logits.Clone();

            for (int k = 0; k < _topK; k++)
            {
                int maxIdx = 0;
                float maxVal = float.MinValue;
                for (int i = 0; i < _numExperts; i++)
                {
                    if (tempLogits[i] > maxVal)
                    {
                        maxVal = tempLogits[i];
                        maxIdx = i;
                    }
                }
                selectedExperts[k] = maxIdx;
                tempLogits[maxIdx] = float.MinValue; // Gating Selection Mask
            }
            return selectedExperts;
        }
    }
}
