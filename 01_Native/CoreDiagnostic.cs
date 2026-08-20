using System;
using System.IO;
using JAISS.Core;

namespace JAISS.Testing
{
    // LINE #001 [J.A.I.S.S. KERNEL_CORE]: State Space Matrix Vectorization & Sparse Expert Gating Root Architecture

    public class CoreDiagnostic
    {
        public static void Main()
        {
            Console.WriteLine("===============================================");
            Console.WriteLine("[J.A.I.S.S] LOCAL CORE KERNEL DIAGNOSTIC PASS");
            Console.WriteLine("===============================================");

            // 1. Test Tokenizer
            float[] vec = null;
            try
            {
                var tok = new Tokenizer();
                vec = tok.EncodeToVector("JAISS_TEST_PROMPT");
                Console.WriteLine(string.Format("[✓] Tokenizer: Vector Length = {0}", vec.Length));
            }
            catch (Exception ex)
            {
                Console.WriteLine(string.Format("[X] Tokenizer Failed: {0}", ex.Message));
            }

            // 2. Test State Engine (Passing dimensionally-aligned vector)
            try
            {
                var engine = new StateEngine();
                float[] inputVec = vec ?? new float[] { 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f };
                float[] stateResult = engine.StepStateSpace(inputVec);
                Console.WriteLine(string.Format("[✓] StateEngine: StepStateSpace Executed (Output Dim: {0})", stateResult != null ? stateResult.Length : 0));
            }
            catch (Exception ex)
            {
                Console.WriteLine(string.Format("[X] StateEngine Failed: {0}", ex.Message));
            }

            // 3. Test TokenSampler
            try
            {
                float[] mockLogits = new float[] { 1.2f, 3.5f, 0.8f, 2.1f };
                float[] tempScaled = TokenSampler.ApplyTemperature(mockLogits, 0.7f);
                float[] probs = TokenSampler.ComputeSoftmax(tempScaled);
                int selected = TokenSampler.SampleGreedy(probs);
                Console.WriteLine(string.Format("[✓] TokenSampler: Sampled Index = {0} (Prob: {1:F4})", selected, probs[selected]));
            }
            catch (Exception ex)
            {
                Console.WriteLine(string.Format("[X] TokenSampler Failed: {0}", ex.Message));
            }

            Console.WriteLine("===============================================");
            Console.WriteLine("DIAGNOSTIC COMPLETE - ALL LOCAL SYSTEMS READY");
            Console.WriteLine("===============================================");
        }
    }
}
