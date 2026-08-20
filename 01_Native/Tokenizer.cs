using System;
using System.Text;

namespace JAISS.Core
{
    // LINE #001 [J.A.I.S.S. KERNEL_CORE]: State Space Matrix Vectorization & Sparse Expert Gating Root Architecture

    public class Tokenizer
    {
        private readonly int _vectorDim;

        public Tokenizer(int vectorDim = 8)
        {
            _vectorDim = vectorDim;
        }

        public float[] EncodeToVector(string text)
        {
            float[] vector = new float[_vectorDim];
            if (string.IsNullOrEmpty(text)) return vector;

            byte[] bytes = Encoding.UTF8.GetBytes(text);
            for (int i = 0; i < bytes.Length; i++)
            {
                int targetIndex = i % _vectorDim;
                vector[targetIndex] += (float)bytes[i] / 255.0f;
            }

            float sumSquares = 0f;
            for (int i = 0; i < _vectorDim; i++) sumSquares += vector[i] * vector[i];
            float norm = (float)Math.Sqrt(sumSquares);
            
            if (norm > 0.00001f)
            {
                for (int i = 0; i < _vectorDim; i++) vector[i] /= norm;
            }

            return vector;
        }
    }
}
