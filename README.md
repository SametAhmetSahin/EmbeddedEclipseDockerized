# EmbeddedEclipseDockerized
Eclipse IDE for Embedded C/C++ Development, Dockerized

## English
#TODO

## Türkçe

Bu projeyi geliştirme amacım okulumdaki öğrencilerin Eclipse ile Tiva C programlayacakları zaman ortamın kurulumunda yaşadıkları sorunlara ve verdikleri uğraşlara bir çözüm sunmaktı.

Yapmam gereken şeyler kabaca şöyleydi:
1. Eclipse'i Dockerlamak
2. X11 Forwarding yapmak (Eclipse arayüzünü görmek ve kullanabilmek için)
3. Projelerin kaydedilmesi ve paylaşılabilmesi amacıyla projeler klasörünü kullanıcının ev klasörüne bağlamak
4. Eclipse'de Tiva C programlayabilmek için konfigürasyon yapmak

### Çabuk Kurulum
`git clone url` ile bu repoyu klonlayın, ardından klasöre Eclipse'i Dockerlamak için gerekenler adımında linki verilmiş Eclipse IDE'sini indirip eclipse klasörünü repo klasörüne kopyalayın, ardından `chmod +x build.sh run.sh` ile build.sh ve run.sh'ı çalıştırılabilir yapın ve `./build.sh` ile containerı buildleyin ardından `./run.sh` ile buildenen containerı çalıştırın. 

#### Eclipse'i Dockerlamak için gerekenler
Öncelikle https://www.eclipse.org/downloads/packages/ sayfasında aşağı kaydırarak Eclipse IDE for Embedded C/C++ Developers kısmındaın Linux x86_64 (mimarinize göre aarch64 de indirebilirsiniz) sürümünü indirip çıkarmanız gerekiyor. Çıkardığınızda eclipse adında bir klasör, içinde de çalıştırılabilir eclipse dosyasını ve diğer klasörleri göreceksiniz.

Aynı zamanda paket yöneticinizi kullanarak docker kurmanız gerekiyor.

Eclipse'in kendisini Dockerlamak kolay oldu ancak kurulmuş halini Dockerlamak birçok soruna yol açtı (kullanıcının ev klasöründe oluşturulan .p2 klasörünü bulamaması, JRE'yi tespit edememesi vb.) ve bu sebeple installerdan kurulmuş halini değil de doğrudan kendisini Dockerlamayı seçtim (Eclipse web sitesinde ayrı olarak sunuluyor).

Dockerlayabilmek için ilk yapmam gereken şey bir Dockerfile oluşturmaktı

Dockerfile oluşturmak için Docker Dökümantasyonundan yardım aldım, ve Dockerfile'ların nasıl çalıştığına dair bilgi edindim.

### Dockerfile Yazmak
Bir Docker containerı oluşturmak için olmazsa olmazımız Dockerfile'dır ve her Dockerfile'ın olmazsa olmazı da Docker containerının neyi baz alacağını belirten **FROM** komutudur. Bu container için Ubuntu'nun Focal sürümünü kullanmayı seçtim, ve dosyanın başına **FROM ubuntu:focal** ekledim.

Ardından Eclipse IDE'sinin ve proje klasörünün yer alacağı bir /apps klasörü oluşturdum, bunu da **WORKDIR /apps** ile gerçekleştirdim.
Sonrasında build klasörümdeki Eclipse IDEsini /apps'e kopyalamak için **COPY . /apps** komutunu kullandım.

İnternette okuduğum kadarıyla otomatik olarak kapanmasını eklemek için en sona `CMD tail -f /dev/null` eklemek gerekiyormuş, onu da yaptım. Tam olarak neden gerekli olduğuna dair araştırmamı yapacağım.

Yaptıklarımdan sonra Dockerfile şöyle bir şey olmuştu:

`FROM ubuntu:focal`  
`WORKDIR /apps`  
`COPY . /apps`  
`CMD tail -f /dev/null`  

### İlk Build
Dockerfile'ı yazdıktan sonra deneme amacıyla containerı Dockerfile'ın ve eclipse klasörünün olduğu klasördeyken `sudo DOCKER_BUILDKIT=1 docker build -t embeddedeclipsetest .`ile buildledim. (Kullanıcımı docker grubuna eklemediğim için sudo kullanmam gerekti.)
Ardından `sudo docker run --rm -it embeddedeclipsetest /bin/bash` ile containerımı çalıştırdım ve container içindeki bash girdisi önüme geldi. Containerım sorunsuz bir şekilde çalışıyordu.
`cd eclipse` ile eclipse klasörüne girdim ve `./eclipse` ile eclipse'i çalıştırmaya çalıştım ancak program bazı eksik kütüphanelerin olduğunu belirterek açılmayı reddetti.
Belirttiği kütüphaneleri apt search ile aradım, kurdum, ve her buildde otomatik olarak kurulması için Dockerfile'da son komut olmamak üzere
`RUN apt update`  
`RUN apt install -y --no-install-recommends libxcursor1 libxinerama1 libxrandr2 libxi6 libswt-gtk-4-jni`
komutlarını ekledim.

Bunlara xterm'i de ekledim ki arayüzü başlatma konusunda bana yardımcı olsun ve elimde bir terminalim olsun.

### X'i aktarıp arayüzü göstertmek

Araştırmalarım sonucunda Docker containerlarında arayüz kullanabilmek için /tmp/ klasöründeki .X11-unix dosyasını containera aktarmak ve bir DISPLAY belirtmek gerekiyormuş, ben de bunu yaptım. Çalıştırma komutum
`sudo docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=:0 embeddedeclipsetest xterm` oldu.

Bu adımda uzun build ve çalıştırma komutunu geçmişte tekrar bulmaya uğraşmamak için `build.sh` ve `run.sh` adında iki script oluşturdum, bunu yapmam daha fazla komut eklerken faydalı oldu.

Ancak çalıştırdığımda xterm %s ekranını bulamamaktan dolayı şikayetçiydi, o sorunu çözmek için internette araştırma yaptım ancak bir satırın gözümden kaçması sebebiyle bir sürü araştırma yapmam gerekti. Sorun ana makinedeki X serverın dışarıdan pencere kabul etmemesiymiş, kabul etmesini `xhost +`komutu ile sağladım ve ana makinede o komutu girip containerı tekrar başlatınca xterm ekranı karşımda belirdi.
başlatmadaki `xterm` komutunu `/apps/eclipse/eclipse` ile değiştirdiğimde de Eclipse'in proje klasörü olarak nereyi seçeğini sorduğu ekran beni karşıladı. Bir satırın gözümden kaçması sebebiyle beni en çok uğraştıran adımı da sonunda bitirmiştim, geriye basit kısımlar kalmıştı.

### Bazı ayarlamalar

#### Proje klasörü
Artık arayüzümüz vardı ve Eclipse çalışıyordu, ama işimiz henüz bitmemişti. Biz container'ı doğrudan imajdan çalıştırdığımız için container çalışırken yapılanlar kaydedilmez, bir sonrakinde temiz bir konfigürasyonla başlar. Ancak ana makineden çeşitli yolları containerda çeşitli yollara atayarak bazı şeylerin kaydedilmesini ve farklı oturumlar arasında paylaşılmasını sağlayabiliriz. Bunun için çalıştırma komutuna `-v "/home/$USER/EmbeddedEclipse/projects/:/apps/projects/:rw"` argümanını ekledim, bu sayede kullanıcının ev klasöründe EmbeddedEclipse ve onun da altında projects diye bir klasör oluşturtup bunu containerda /apps/projects yoluna okuma ve yazma izinleri olacak şekilde atanmasını sağladım. Yapılması gereken son şey ise Eclipse'i konfigüre ederken proje klasörü olarak burayı seçmekti.

#### USB Yönlendirme
Programlayacağımız Tiva C'ye USB ile doğrudan bağlı olmamız gerekiyordu, bundan dolayı da çalıştırma komutuna `--device /dev/bus/usb/002` ekleyerek 2. hubdaki USByi containera aktardım, ana makineye bağlı olarak değişmesi gereken tek şey bu.

### Son ayarlar
Hocamın bana attığı rehberi takip ederek Dockerfile'daki `apt install` komutuna `openocd` ve `gcc-arm-none-eabi` paketlerini de ekledim. Elimde Tiva C bulunmadığı için test yapamadım ama teorik olarak çalışması gerekiyor, hocamla beraber Eclipse'deki son ayarlamaları gerçekleştirip containerı sunabileceğimizi düşünüyorum.

### Son dosyalar
Dockerfile, run.sh ve build.sh repoda dosya olarak bulunmaktadır.

### Son sözler
Eclipse'de kullanıcıların kendi yaptığı konfigürasyonun da kaydedilmesi için kullanıcının ev klasöründeki EmbeddedEclipse klasörünün altına configuration diye bir klasör oluşturup bunu /apps/configuration'a bağlayıp eclipse'in configuration klasörünü sembolik bir şekilde bağlamak (`ln -s` ile, ancak ne kadar doğru olur bilmiyorum, denemek gerekiyor.). 

Container boyutu şu an Eclipse IDE'sini içinde bulundurduğu için 1.35 GB, ancak container içinde bulunması sanal makinelere kıyasla hem daha performanslı, hem ana makinenin kaynaklarını kendine ayırmıyor, hem de daha esnek. Aynı zamanda ihtiyaç duyulduğu zaman düzenlenmesi de oldukça basit.
