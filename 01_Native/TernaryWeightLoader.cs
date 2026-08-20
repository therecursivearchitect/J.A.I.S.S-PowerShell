using System;
using System.IO;
using System.Runtime.InteropServices;

namespace JAISS.Core
{
    public class TernaryWeightLoader
    {
        [DllImport("nvcuda.dll", EntryPoint = "cuMemHostAlloc")]
        public static extern int cuMemHostAlloc(out IntPtr ppv, ulong bytesize, uint flags);

        [DllImport("nvcuda.dll", EntryPoint = "cuMemFreeHost")]
        public static extern int cuMemFreeHost(IntPtr p);

        public unsafe byte* LoadUnmanagedTernaryWeights(string filepath, out ulong size)
        {
            if (!File.Exists(filepath)) throw new FileNotFoundException(filepath);

            byte[] bytes = File.ReadAllBytes(filepath);
            size = (ulong)bytes.Length;

            IntPtr hostBuffer;
            int status = cuMemHostAlloc(out hostBuffer, size, 0x01); // CU_MEMHOSTALLOC_PORTABLE
            if (status != 0) throw new ExternalException("cuMemHostAlloc failed with code " + status);

            Marshal.Copy(bytes, 0, hostBuffer, bytes.Length);
            return (byte*)hostBuffer.ToPointer();
        }
    }
}
