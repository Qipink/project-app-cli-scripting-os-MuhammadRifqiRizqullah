#!/bin/bash

# KONFIGURASI WARNA
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[0;33m'
BIRU='\033[0;34m'
CYAN='\033[0;36m'
TEBAL='\033[1m'
NC='\033[0m' 

# VARIABEL & ARRAY
daftar_barang=()
daftar_harga=()
budget=0
total_belanja=0

function header_app() {
    clear
    echo -e "${BIRU}========================================${NC}"
    echo -e "${CYAN}${TEBAL}      SISTEM PENGELOLA KEUANGAN      ${NC}"
    echo -e "${BIRU}========================================${NC}"
}

function reset_data() {
    header_app
    echo -e "${MERAH}${TEBAL}[PERINGATAN HAPUS DATA]${NC}"
    echo -e "Anda akan menghapus semua riwayat belanja."
    echo -e "Budget awal tidak akan berubah."
    echo ""
    
    echo -ne "Apakah anda yakin? (${HIJAU}y${NC}/${MERAH}n${NC}): "
    read konfirmasi
    
    case "$konfirmasi" in
        y|Y)
            daftar_barang=()
            daftar_harga=()
        
            echo ""
            echo -e "${HIJAU}Data belanja berhasil di-reset! ${NC}"
            ;;
        n|N)
            echo ""
            echo -e "${KUNING}Batal menghapus data.${NC}" 
            ;;
        *) 
            echo ""
            echo -e "${KUNING}Input tidak dikenali.${NC}"
            sleep 1
            reset_data
            ;;
    esac 

    sleep 1.5
}

function cek_status() {
    total_belanja=0
    for harga in "${daftar_harga[@]}"; do
        total_belanja=$((total_belanja + harga))
    done

    sisa=$((budget - total_belanja))

    header_app
    echo -e "${TEBAL}Laporan Keuangan:${NC}"
    echo -e "Budget Awal   : ${CYAN}Rp $budget${NC}"
    echo -e "Total Belanja : ${KUNING}Rp $total_belanja${NC}"

    if [ $total_belanja -gt $budget ]; then
        echo -e "Sisa Uang     : ${MERAH}Rp $sisa (MINUS!)${NC}"
        echo -e "\n${MERAH}[PERINGATAN]${NC} Anda boros! Kurangi jajan."
    elif [ $sisa -eq 0 ]; then
        echo -e "Sisa Uang     : ${KUNING}Rp 0${NC}"
        echo -e "\n${KUNING}[INFO]${NC} Hati-hati, uang habis pas."
    else
        echo -e "Sisa Uang     : ${HIJAU}Rp $sisa${NC}"
        echo -e "\n${HIJAU}[AMAN]${NC} Keuangan sehat."
    fi
    
    echo -e "${BIRU}----------------------------------------${NC}"
    read -p "Tekan Enter kembali ke menu..."
}

function tambah_data() {
    header_app
    echo -e "${TEBAL}Tambah Pengeluaran Baru${NC}"
    
    echo -n "Masukkan Nama Barang : "
    read nama_baru
    
    echo -n "Masukkan Harga (Rp)  : "
    read harga_baru

    if [[ ! $harga_baru =~ ^[0-9]+$ ]]; then
        echo -e "${MERAH}Error: Harga harus berupa angka!${NC}"
        sleep 2
        return
    fi

    daftar_barang+=("$nama_baru")
    daftar_harga+=("$harga_baru")
    
    echo -e "${HIJAU}Sukses! Data '$nama_baru' disimpan.${NC}"
    sleep 1.5
}

function lihat_data() {
    header_app
    echo -e "${TEBAL}Rincian Belanja:${NC}"
    
    nomor=0
    count=${#daftar_harga[@]}

    if [ $count -eq 0 ]; then
        echo -e "${KUNING}Belum ada data belanja.${NC}"
    else
        for harga in "${daftar_harga[@]}"; do
            barang="${daftar_barang[$nomor]}"
            echo -e "${CYAN}$((nomor + 1)).${NC} $barang \t = Rp $harga"
            nomor=$((nomor + 1))
        done
    fi
    echo -e "${BIRU}----------------------------------------${NC}"
    read -p "Tekan Enter kembali ke menu..."
}

# 3. PROGRAM UTAMA
header_app
echo ""
echo -e "Selamat Datang di ${TEBAL} Sistem Pengelola Keuangan${NC}!"
echo ""
echo -ne "Masukkan Budget Awal (${HIJAU}Angka${NC}): "
read budget

while true; do
    header_app
    # Hitung total belanja ulang agar display menu selalu update
    total_belanja=0
    for h in "${daftar_harga[@]}"; do
        total_belanja=$((total_belanja + h))
    done
    sisa=$((budget - total_belanja))
    
    echo -e "Status Saat Ini:"
    echo -e "Budget      ------- ${CYAN}Rp $budget${NC}"
    echo -e "Pengeluaran ------- ${KUNING}Rp $total_belanja${NC}"
    echo -e "Sisa        ------- ${CYAN}Rp $sisa${NC}"
    echo ""
    echo -e "${TEBAL}MENU UTAMA:${NC}"
    echo -e "${HIJAU}[1]${NC} Cek Status & Sisa"
    echo -e "${HIJAU}[2]${NC} Tambah Pengeluaran"
    echo -e "${HIJAU}[3]${NC} Lihat Rincian"
    echo -e "${KUNING}[4]${NC} Reset Data Belanja (Baru)"
    echo -e "${MERAH}[5]${NC} Keluar"
    
    echo ""
    echo -ne "Pilih menu (1-5): "
    read pilihan

    case $pilihan in
        1) cek_status ;;
        2) tambah_data ;;
        3) lihat_data ;;
        4) reset_data ;;
        5) 
            echo -e "${CYAN}Terima kasih! Hemat pangkal kaya.${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${MERAH}Pilihan tidak valid!${NC}"
            sleep 1
            ;;
    esac
done