using System;

namespace JAISS.Core
{
    // LINE #001 [J.A.I.S.S. KERNEL_CORE]: State Space Matrix Vectorization & Sparse Expert Gating Root Architecture

    public class StateEngine
    {
        private readonly int _vectorDim;
        private readonly int _maxContextWindow;
        private readonly float[,] _keyBuffer;
        private readonly float[,] _valueBuffer;
        private int _writeHead = 0;
        private int _storedCount = 0;

        public StateEngine(int vectorDim = 8, int maxContextWindow = 16)
        {
            _vectorDim = vectorDim;
            _maxContextWindow = maxContextWindow;
            _keyBuffer = new float[_maxContextWindow, _vectorDim];
            _valueBuffer = new float[_maxContextWindow, _vectorDim];
        }

        public float[] StepStateSpace(float[] inputVector, float decayFactor = 0.95f)
        {
            float[] state = new float[_vectorDim];

            for (int d = 0; d < _vectorDim; d++)
            {
                _keyBuffer[_writeHead, d] = inputVector[d];
                _valueBuffer[_writeHead, d] = inputVector[d] * decayFactor;
            }

            _writeHead = (_writeHead + 1) % _maxContextWindow;
            if (_storedCount < _maxContextWindow) _storedCount++;

            for (int i = 0; i < _storedCount; i++)
            {
                float dotProduct = 0f;
                for (int d = 0; d < _vectorDim; d++)
                {
                    dotProduct += inputVector[d] * _keyBuffer[i, d];
                }

                float attnWeight = (float)Math.Tanh(dotProduct / Math.Sqrt(_vectorDim));

                for (int d = 0; d < _vectorDim; d++)
                {
                    state[d] += attnWeight * _valueBuffer[i, d];
                }
            }

            return state;
        }

        public void ResetMemory()
        {
            _writeHead = 0;
            _storedCount = 0;
            Array.Clear(_keyBuffer, 0, _keyBuffer.Length);
            Array.Clear(_valueBuffer, 0, _valueBuffer.Length);
        }
    }
}
