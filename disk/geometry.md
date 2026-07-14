# Disk geometry and ordering hypotheses

The canonical input is a raw 143,360-byte sector image. It can be divided
losslessly into 35 tracks × 16 stored sectors × 256 bytes. A sector image does
not retain nibble timing, address fields, physical rotational position, or weak
bits, so this project does not claim nibble-level geometry.

The recovery tool retains three reversible byte permutations:

- `file-linear`: raw file-sector positions 0 through 15 stay in order.
- `physical-indexed-dos33`: interpret raw positions as controller sector IDs,
  then select them with the conventional DOS 3.3 logical-to-physical
  translation `[0,13,11,9,7,5,3,1,14,12,10,8,6,4,2,15]`.
- `physical-indexed-prodos`: interpret raw positions as controller sector IDs,
  then apply `[0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15]`.

The boot stage selects controller sector IDs through the DOS translation table,
while the corresponding content is found at raw file-sector positions 0..5.
The `$BCFF/$BD00` boundary is coherent only under that DOS-logical file-order
interpretation. This confirms the ordering used by the boot stage, not a DOS
filesystem: the image does not catalog with a2kit 4.4.2 and uses a custom loader.
