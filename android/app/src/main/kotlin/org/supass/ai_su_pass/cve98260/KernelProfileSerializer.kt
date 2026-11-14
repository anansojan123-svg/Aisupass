package org.supass.ai_su_pass.cve98260

import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * 把 KernelProfile 序列化为与原生 kernel_table.c 严格对齐的 stdin 报文。
 *
 * 报文 = 4 字节大端长度前缀（= [BLOB_SIZE]）+ 308 字节定长 blob。
 * kernel_table.c 先读长度再读 blob；不带前缀会把 magic "C982"
 * 当成长度（1127823410），profile 被丢弃并回落到内置表。
 *
 * blob 布局（全小端，共 308 字节，version 4）：
 *   0    magic[4] "C982"
 *   4    u16 version = 4
 *   6    u16 flags (bit0 = recommend_shizuku)
 *   8    u64 page_offset
 *   16   u64 timer_link
 *   24   u64 cred_link
 *   32   u64 selinux_link
 *   40   u64 user_ns
 *   48   u64 root_user
 *   56   u64 groups
 *   64   u64 ucounts
 *   72   u32 task_cred
 *   76   u32 task_struct_size
 *   80   u32 cred_uid
 *   84   u32 kitimer_node
 *   88   char release[128]
 *   216  char vuln_type[32]
 *   248  u64 kitimer_size
 *   256  u64 task_alloc_link   (version 3 起)
 *   264  u32 cred_size         (version 4 起)
 *   268  u32 cred_cap_inh
 *   272  u32 cred_cap_perm
 *   276  u32 cred_cap_eff
 *   280  u32 cred_cap_bset
 *   284  u32 cred_cap_amb
 *   288  u32 cred_security
 *   292  u32 cred_user
 *   296  u32 cred_user_ns
 *   300  u32 cred_ucounts
 *   304  u32 cred_groups
 */
object KernelProfileSerializer {

    const val BLOB_SIZE = 308
    private const val PREFIX_SIZE = 4
    private const val MAGIC = "C982"
    private const val VERSION: Short = 4

    fun serialize(profile: KernelProfile): ByteArray {
        val buf = ByteBuffer.allocate(PREFIX_SIZE + BLOB_SIZE)
            .order(ByteOrder.BIG_ENDIAN)
        buf.putInt(BLOB_SIZE)                                  // 长度前缀（大端）
        buf.order(ByteOrder.LITTLE_ENDIAN)
        buf.put(MAGIC.toByteArray(Charsets.US_ASCII))          // 0..3
        buf.putShort(VERSION)                                   // 4..5
        buf.putShort(if (profile.recommendShizuku) 1 else 0)    // 6..7
        buf.putLong(profile.pageOffset)                         // 8
        buf.putLong(profile.timerLink)                          // 16
        buf.putLong(profile.credLink)                           // 24
        buf.putLong(profile.selinuxLink)                        // 32
        buf.putLong(profile.userNs)                             // 40
        buf.putLong(profile.rootUser)                           // 48
        buf.putLong(profile.groups)                             // 56
        buf.putLong(profile.ucounts)                            // 64
        buf.putInt(profile.taskCred)                            // 72
        buf.putInt(profile.taskStructSize)                      // 76
        buf.putInt(profile.credUid)                             // 80
        buf.putInt(profile.kitimerNode)                         // 84
        putFixedString(buf, profile.release, 128)              // 88..215
        putFixedString(buf, profile.vulnType, 32)              // 216..247
        buf.putLong(profile.kitimerSize)                        // 248..255
        buf.putLong(profile.taskAllocLink)                      // 256..263
        buf.putInt(profile.credSize)                            // 264
        buf.putInt(profile.credCapInheritable)                  // 268
        buf.putInt(profile.credCapPermitted)                    // 272
        buf.putInt(profile.credCapEffective)                    // 276
        buf.putInt(profile.credCapBset)                         // 280
        buf.putInt(profile.credCapAmbient)                      // 284
        buf.putInt(profile.credSecurity)                        // 288
        buf.putInt(profile.credUser)                            // 292
        buf.putInt(profile.credUserNs)                          // 296
        buf.putInt(profile.credUcounts)                         // 300
        buf.putInt(profile.credGroups)                          // 304..307
        return buf.array()
    }

    private fun putFixedString(buf: ByteBuffer, value: String, size: Int) {
        val bytes = value.toByteArray(Charsets.UTF_8)
        val n = minOf(bytes.size, size - 1)
        buf.put(bytes, 0, n)
        repeat(size - n) { buf.put(0) }
    }
}
