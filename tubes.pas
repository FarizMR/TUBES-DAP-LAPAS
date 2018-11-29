program lapasEmeraldCity;
uses crt,sysutils;

const
	maxKapasitas = 100;

type tabelDataNarapidana = record
	id : Integer;
	nama : String;
	tingkat : String;
	masaTahanan : Integer;
	poin : Integer;
end;

type TNapi = array[1..maxKapasitas] of tabelDataNarapidana;

var
	arrNapi : TNapi;
	chooser : String;
	FileTabelNapi : file of TNapi;

	function getLastIDNapi(arr : TNapi) : Integer;
	{Menggunakan sequential search}
	var
		i: Integer;
		last_id : integer;
	begin
		i := 1;
		last_id := 0;
		while (i < Length(arr)) do
		begin
			if arr[i].id > arr[i + 1].id then
			begin
				last_id := arr[i].id;
			end;
			i := i + 1
		end;
		getLastIDNapi := last_id + 1;
	end;

	function getEmptyArray(arr : TNapi): Integer;
	{Menggunakan sequential search}
	var
		i: Integer;
	begin
		i := 0;
		repeat
			i := i + 1;
		until (arr[i].id = 0);
		getEmptyArray := i;
	end;

	function getTotalNapi(arr : TNapi): Integer;
	{Menggunakan sequential search}
	var
		i : Integer;
		total : Integer;
	begin
		total := 0;
		for i := 1 to Length(arr) do
		begin
			if arr[i].id <> 0 then
				total := total + 1;
		end;
		getTotalNapi := total;
	end;

	procedure lihatDetilNarapidana(idx : Integer);
	begin
		writeln('======== [', arrNapi[idx].id, '] ========');
		writeln(' Nama         : ',arrNapi[idx].nama);
		writeln(' Tingkat      : ', arrNapi[idx].tingkat);
		writeln(' Masa Tahanan : ', arrNapi[idx].masaTahanan, ' tahun');
		writeln(' Poin         : ', arrNapi[idx].poin);
		if(arrNapi[idx].poin <= arrNapi[idx].masaTahanan*100) then
			writeln(' ', arrNapi[idx].nama, ' butuh ', arrNapi[idx].masaTahanan*100 - arrNapi[idx].poin + 1, ' poin lagi untuk mendapat remisi.' );
		if(arrNapi[idx].poin > arrNapi[idx].masaTahanan*100) then
			writeln(' ', arrNapi[idx].nama, ', telah memenuhi syarat untuk mendapat REMISI');
	end;

	procedure lihatDataNapi(var T : TNapi);
	{I.S. terdefinisi tabel TNapi
	F.S. muncul isi dari array yang sudah memiliki elemen}
	var
		i: Integer;
		chooser : Integer;
		dataFound : Boolean;
	begin
		clrscr;
		writeln('*Data Narapidana Lapas Emerald City');
		writeln('id - nama - tingkat - masa tahanan');
		writeln('================================');
		for i := 1 to Length(T) do
		begin
			if (T[i].id > 0) then
			begin
				if(T[i].poin > T[i].masaTahanan*100) then
					writeln(T[i].id, ' ', T[i].poin, ' ', T[i].nama, ' - ', T[i].tingkat, ' - ', T[i].masaTahanan, ' tahun ', ' <= berhak REMISI')
				else
					writeln(T[i].id, ' ', T[i].poin, ' ', T[i].nama, ' - ', T[i].tingkat, ' - ', T[i].masaTahanan, ' tahun ');
			end;
		end;
		repeat
		begin
			writeln('Ketik ID Narapidana utk melihat lebih detil / ketik 0 untuk menuju ke menu awal');
			readln(chooser);
			if ((chooser > 0) and (chooser < 101)) then
			begin
				dataFound := false;
				{mencari ID menggunakan sequential search}
				for i := 1 to Length(T) do
				begin
					if chooser = T[i].id then
					begin
						lihatDetilNarapidana(i);
						dataFound := true;
					end;
				end;
				if dataFound = false then
				begin
					writeln('*Data tidak ditemukan');
				end;
			end;
		end;
		until(chooser = 0);
	end;

	procedure inputDataNapi(var T : TNapi);
	{I.S. terdefinisi TNapi
	F.S. array terisi dengan data narapidana sesuai dengan jumlah yg ingin ditambahkan}
	var
		jumlahNapi : Integer;
		i : Integer;
		lastID : Integer;
		emptyArr : Integer;
	begin
		clrscr;
		writeln('*Input Data Narapidana');
		write('Jumlah Napi : ');
		readln(jumlahNapi);

		for i := 1 to jumlahNapi do
		begin
			lastID := getLastIDNapi(T);
			emptyArr := getEmptyArray(T);
			writeln('No ID : ', lastID);
			T[emptyArr].id := lastID;
			T[emptyArr].poin := 0;
			write('Nama : ');
			readln(T[emptyArr].nama);
			write('Tingkat : ');
			readln(T[emptyArr].tingkat);
			write('Masa Tahanan (tahun) : ');
			readln(T[emptyArr].masaTahanan);
			writeln();
		end;
		writeln('**');
	end;

	procedure editDataNapi(var T : TNapi);
	var
		idx: Integer;
		chooser : String;
		poinTambahan : Integer;
		dataFound :  Boolean;
		i : integer;
	begin
		clrscr;
		write('Masukkan ID Napi : ');
		readln(idx);
		dataFound := false;
		i := 0;
		repeat
		begin
			i := i + 1;
			if T[i].id = idx then
			begin
				dataFound := true;
			end;
		end;	
		until ((dataFound = true) or (i = Length(T)));
		if dataFound = false then
		begin
			writeln('id ', idx, ' data tidak ditemukan');
			delay(500);
		end;

		if dataFound = true then
		begin
			writeln('===== [', T[i].id, '] =====');
			writeln('Nama : ', T[i].nama);
			writeln('Tingkat : ', T[i].tingkat);
			writeln('Masa Tahanan (tahun) : ', T[i].masaTahanan);
			writeln('Poin : ', T[i].poin);
			writeln('===========');
			writeln('	(A) Edit Data Narapidana');
			writeln('	(B) Update Poin');
			readln(chooser);
			if ((chooser = 'a') or (chooser = 'A')) then
			begin
				write('Nama : ');
				readln(T[i].nama);
				write('Tingkat : ');
				readln(T[i].tingkat);
				write('Masa Tahanan (tahun) : ');
				readln(T[i].masaTahanan);
				write('Poin : ');
				readln(T[i].poin);
			end;
			if ((chooser = 'b') or (chooser = 'B')) then
			begin
				write('Tambah : ');
				readln(poinTambahan);
				T[i].poin := T[i].poin + poinTambahan;
			end;
		end;
	end;

	procedure hapusDataNapi(var T : TNapi);
	{ I.S. mendapatkan array TNapi
	F.S. menghapus data di dalam TNapi dengan menimpa elemen array yg dihapus dgn array selanjutnya
	lalu menimpa array selanjutnya dengan selanjutnya lagi hingga array yg mempunyai elemen telah ber-
	pindah ke indeks bawahnya}
	var
		idx: Integer;
		chooser : String;
		i : integer;
		j : integer;
		dataFound : Boolean;
	begin
		clrscr;
		writeln('*Hapus Data Narapidana');
		write('ID : ');
		readln(idx);
		dataFound := false;
		i := 0;
		repeat
		begin
			i := i + 1;
			if T[i].id = idx then
			begin
				dataFound := true;
			end;
		end;	
		until ((dataFound = true) or (i = Length(T)));

		if dataFound = true then
		begin
			writeln('=========== [', T[i].id, '] ===========');
			writeln('Nama : ', T[i].nama);
			writeln('Masa Tahanan : ', T[i].masaTahanan);
			writeln('Tingkat : ', T[i].tingkat);
			writeln('Poin : ', T[i].poin);
			dataFound := true;
			writeln('Apakah anda yakin untuk menghapus [', T[i].id, '] ', T[i].nama, '? (y/n)');
			readln(chooser);
			if (chooser = 'Y') or (chooser = 'y') then
			begin
				writeln('[',T[i].id, '] ', T[i].nama, ' berhasil dihapus!');
				for j := i to Length(T)-1 do
					T[j] := T[j + 1];
				delay(1000);
			end;
			if (chooser = 'N') or (chooser = 'n') then
			begin
				hapusDataNapi(T);
			end;
		end;

		if(dataFound = false) then
		begin
			writeln('*Data tidak ditemukan');
			writeln('-Akan di kembalikan ke menu awal');
			delay(500);
		end;
	end;

	procedure sortingNapiPoinTerbesar(T: TNapi);
	{Menggunakan insertion sort}
	var
		total_napi : Integer;
		i : integer;
		posisi : integer;
		temp : tabelDataNarapidana;
	begin
		total_napi := getTotalNapi(T);		
		for i := 1 to total_napi do
		begin
			posisi := i;
			temp := T[i];
			while (posisi > 0) and (T[posisi - 1].poin < temp.poin) do
			begin
				T[posisi] := T[posisi-1];
				posisi := posisi - 1;
			end;
			T[posisi] := temp;
		end;
		
		clrscr;
		writeln('*Data terurut berdasarkan poin terbesar');
		writeln('ID - Nama - Poin');
		for i := 1 to total_napi do
		begin
			writeln(T[i].id, ' ',T[i].nama, ' ', T[i].poin);
		end;
		readln();
	end;

	procedure sortingNapiPoinTerkecil(T: TNapi);
	{Menggunakan selection sort}
	var
		i : integer;
		j : integer;
		min : integer;
		tmp : tabelDataNarapidana;
		total_napi : Integer;
	begin
		total_napi := getTotalNapi(T);
		for i := 1 to total_napi - 1 do
		begin
			min := i;
			for j := i + 1 to total_napi do
			begin
				if(T[j].poin < T[min].poin) then
				begin
					min := j;
				end;
			end;
			tmp := T[min];
			T[min] := T[i];
			T[i] := tmp;
		end;

		clrscr;
		writeln('*Data terurut berdasarkan poin terkecil');
		writeln('ID - Nama - Poin');
		for i := 1 to total_napi do
		begin
			writeln(T[i].id, ' ',T[i].nama, ' ', T[i].poin);
		end;
		readln();
	end;

	procedure sortingNapiNamaTerbesar(T : TNapi);
	{Menggunakan bubble sort}
	var
		i: Integer;
		j: Integer;
		temp: tabelDataNarapidana;
		total_napi : Integer;
	begin
		total_napi := getTotalNapi(T);
		for i := 1 to total_napi - 1 do
		begin
			for j := total_napi downto i + 1 do
			begin
				if(T[j].nama[1] < T[j-1].nama[1]) then
				begin
					temp := T[j];
					T[j] := T[j-1];
					T[j-1] := temp;
				end;
			end;
		end;
		clrscr;
		writeln('*Data terurut berdasarkan huruf depan terkecil (A-Z)');
		writeln('ID - Nama - Poin');
		for i := 1 to total_napi do
		begin
			writeln(T[i].id, ' ',T[i].nama, ' ', T[i].poin);
		end;
		readln();
	end;

	procedure sortingID(T : TNapi);
	var
		i : integer;
		j : integer;
		min : integer;
		tmp : tabelDataNarapidana;
		total_napi : Integer;
	begin
		total_napi := getTotalNapi(T);
		for i := 1 to total_napi - 1 do
		begin
			min := i;
			for j := i + 1 to total_napi do
			begin
				if(T[j].id < T[min].id) then
				begin
					min := j;
				end;
			end;			
			tmp := T[min];
			T[min] := T[i];
			T[i] := tmp;
		end;
		clrscr;
	end;

	procedure cariIDNapi(T: TNapi);
	{Menggunakan binary search}
	var
		bawah: Integer;
		atas: Integer;
		tengah: Integer;
		dataFound: Boolean;
		total_napi : Integer;
		cariID : Integer;
		idx : integer;
	begin
		write('Masukkan ID yang akan dicari : ');
		readln(cariID);

		sortingID(T);

		total_napi := getTotalNapi(T);
		bawah := 1;
		atas := total_napi;
		dataFound := false;
		repeat
			tengah := (atas + bawah) div 2;
			if cariId = T[tengah].id then 
			begin
				dataFound := true;
				idx := tengah;
				break;
			end
			else if cariID < T[tengah].id then
				atas := tengah - 1
			else
				bawah := tengah + 1;
		until atas < bawah;

		if dataFound = true then
		begin
			writeln('Data ditemukan!');
			delay(100);
			writeln('======= [', T[idx].id,'] =======');
			writeln('Nama : ', T[idx].nama);
			writeln('Masa Tahanan : ', T[idx].masaTahanan);
			writeln('Tingkat : ', T[idx].tingkat);
			writeln('Poin : ', T[idx].poin);
		end
		else
			writeln('Data dengan ID "', cariID, '" tidak ditemukan');

		readln();
	end;

begin
	chooser := '';
	if FileExists('filetabnapi.dat') then
	begin
		assign(FileTabelNapi, 'filetabnapi.dat');
		reset(FileTabelNapi);
	end
	else
	begin
		assign(FileTabelNapi, 'filetabnapi.dat');
		rewrite(FileTabelNapi);
		reset(FileTabelNapi);
	end;
	while not eof(FileTabelNapi) do
	begin
		read(FileTabelNapi, arrNapi);
	end;
	repeat
	begin
		clrscr;
		writeln('=== Lapas Emerald City ===');
		writeln('============= PILIH AKSI =============');
		writeln('   (A) Lihat Data Napi');
		writeln('   (B) Input Data Napi');
		writeln('   (C) Kelola Data Napi');
		writeln('   (S) Simpan Perubahan');
		writeln('======================================');
		readln(chooser);
		if (chooser = 'A') or (chooser = 'a') then
		begin
			clrscr;
			delay(200);
			writeln('============= LIHAT =============');
			writeln('     (A) Lihat Semua Data');
			writeln('     (B) Lihat Data Berdasarkan Huruf Depan Terkecil (A-Z)');
			writeln('     (C) Lihat Data Berdasarkan Jumlah Poin Besar - Kecil');
			writeln('     (D) Lihat Data Berdasarkan Jumlah Poin Kecil - Besar');
			writeln('     (E) Cari ID Napi');
			writeln('=================================');
			readln(chooser);
			if (chooser = 'A') or (chooser = 'a') then
				lihatDataNapi(arrNapi); 
			if (chooser = 'B') or (chooser = 'b') then
			begin
				sortingNapiNamaTerbesar(arrNapi);
				chooser:='';
			end;
			if (chooser = 'C') or (chooser = 'c') then
			begin
				sortingNapiPoinTerbesar(arrNapi);
				chooser:='';
			end;
			if (chooser = 'D') or (chooser = 'd') then
			begin
				sortingNapiPoinTerkecil(arrNapi);
				chooser:='';
			end;
			if (chooser = 'E') or (chooser = 'e') then
			begin
				cariIDNapi(arrNapi);
				chooser:='';
			end;
		end;
		if(chooser = 'B') or (chooser = 'b') then
			inputDataNapi(arrNapi);
		if(chooser = 'C') or (chooser = 'c') then
		begin
			writeln('*Kelola Data Napi');
			writeln('==================');
			writeln('	(A) Edit data & Update Poin');
			writeln('	(B) Hapus Data');
			writeln('==================');
			readln(chooser);
			if (chooser = 'A') or (chooser = 'a') then
				editDataNapi(arrNapi);
			if (chooser = 'B') or (chooser = 'b') then
			begin
				hapusDataNapi(arrNapi);
				readln();
			end;
		end;
		if(chooser = 'S') or (chooser = 's') then
		begin
			write(FileTabelNapi, arrNapi);
			writeln('*Data Tersimpan*');
			delay(1000);
		end;
	end;
	until((chooser = 'exit') or (chooser = 'EXIT'));
	Close(FileTabelNapi);
end.