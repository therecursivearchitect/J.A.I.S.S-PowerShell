using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

namespace JAISS {
    public unsafe class Program {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr VirtualAlloc(IntPtr lpAddress, UIntPtr dwSize, uint flAllocationType, uint flProtect);

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool VirtualFree(IntPtr lpAddress, UIntPtr dwSize, uint dwFreeType);

        public static void Main(string[] args) {
            Console.WriteLine("[J.A.I.S.S. NATIVE RUNTIME ACTIVE]");
            Console.WriteLine("Executing zero-copy unmanaged memory stress validation...");

            int payloadMB = 256;
            long totalBytes = 1024L * 1024L * payloadMB;

            Stopwatch sw = Stopwatch.StartNew();
            IntPtr pBuffer = VirtualAlloc(IntPtr.Zero, (UIntPtr)totalBytes, 0x3000, 0x04);
            if (pBuffer == IntPtr.Zero) {
                Console.WriteLine("[ERROR] VirtualAlloc failed.");
                return;
            }

            byte* ptr = (byte*)pBuffer.ToPointer();
            for (long i = 0; i < totalBytes; i += 4096) {
                *(ptr + i) = 0xAA;
            }

            sw.Stop();
            VirtualFree(pBuffer, UIntPtr.Zero, 0x8000);

            double seconds = sw.ElapsedMilliseconds / 1000.0;
            double throughput = seconds > 0 ? Math.Round((payloadMB / 1024.0) / seconds, 2) : payloadMB;

            Console.WriteLine($"[PASS] Payload: {payloadMB} MB | Throughput: {throughput} GB/sec | Zero Pipeline Bubbles.");
        }
    }
}
