$NetBSD: patch-xen_arch_x86_hvm_hvm.c,v 1.1 2014/10/01 17:34:54 bouyer Exp $

x86/HVM: properly bound x2APIC MSR range

While the write path change appears to be purely cosmetic (but still
gets done here for consistency), the read side mistake permitted
accesses beyond the virtual APIC page.

Note that while this isn't fully in line with the specification
(digesting MSRs 0x800-0xBFF for the x2APIC), this is the minimal
possible fix addressing the security issue and getting x2APIC related
code into a consistent shape (elsewhere a 256 rather than 1024 wide
window is being used too). This will be dealt with subsequently.

This is XSA-108.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- xen/arch/x86/hvm/hvm.c.orig
+++ xen/arch/x86/hvm/hvm.c
@@ -4380,7 +4380,7 @@ int hvm_msr_read_intercept(unsigned int 
         *msr_content = vcpu_vlapic(v)->hw.apic_base_msr;
         break;
 
-    case MSR_IA32_APICBASE_MSR ... MSR_IA32_APICBASE_MSR + 0x3ff:
+    case MSR_IA32_APICBASE_MSR ... MSR_IA32_APICBASE_MSR + 0xff:
         if ( hvm_x2apic_msr_read(v, msr, msr_content) )
             goto gp_fault;
         break;
@@ -4506,7 +4506,7 @@ int hvm_msr_write_intercept(unsigned int
         vlapic_tdt_msr_set(vcpu_vlapic(v), msr_content);
         break;
 
-    case MSR_IA32_APICBASE_MSR ... MSR_IA32_APICBASE_MSR + 0x3ff:
+    case MSR_IA32_APICBASE_MSR ... MSR_IA32_APICBASE_MSR + 0xff:
         if ( hvm_x2apic_msr_write(v, msr, msr_content) )
             goto gp_fault;
         break;
