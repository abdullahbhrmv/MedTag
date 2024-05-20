# MedTag

**MedTag**: Kullanıcıların ilaç prospektüslerini okumalarını kolaylaştıran, özet şeklinde önemli bilgileri sunan bir mobil uygulamadır.

## Özellikler

- **Login ve Register**: Kullanıcılar uygulamaya kayıt olabilir ve giriş yapabilirler.
- **İlaç Sayfası**: Kullanıcılar ilaç ismi aratarak ilacın fotoğrafı, kullanımı ve yan etkileri hakkında bilgi alabilirler.
- **Hatırlatıcı Sayfası**: Kullanıcılar ilaç kullanımı için hatırlatıcılar oluşturabilirler.
- **QR ile Tarama**: İlaç kutularındaki QR kodlarını tarayarak ilaca dair bilgileri hızlıca görüntüleyebilirler.
- **Profil**: Kullanıcılar profil bilgilerini görüntüleyip düzenleyebilirler.

## Kullanılan Paketler

- **[cupertino_icons](https://pub.dev/packages/cupertino_icons) (v1.0.6)**: iOS benzeri ikon seti.
- **[http](https://pub.dev/packages/http) (v0.13.3)**: HTTP istekleri göndermek ve almak için.
- **[googleapis](https://pub.dev/packages/googleapis) (v10.0.0)**: Google API'larına erişim sağlamak için.
- **[googleapis_auth](https://pub.dev/packages/googleapis_auth) (v1.2.0)**: Google API'ları için kimlik doğrulama işlemleri.
- **[csv](https://pub.dev/packages/csv) (v5.0.0)**: CSV dosyalarını okumak ve yazmak için.
- **[qr_code_scanner](https://pub.dev/packages/qr_code_scanner) (v1.0.1)**: QR kodları taramak için.

## Veritabanı Bilgileri

MedTag uygulamasında kullanılan ilaç bilgileri kendi veritabanımızda saklanmaktadır. Aşağıda örnek olarak bazı ilaçların bilgilerini bulabilirsiniz:

| Medicine Name | Composition | Uses | Side Effects | Image URL | Manufacturer | Excellent Review % | Average Review % | Poor Review % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Avastin 400mg Injection | Bevacizumab (400mg) | Cancer of colon and rectum, Non-small cell lung cancer, Kidney cancer, Brain tumor, Ovarian cancer, Cervical cancer | Rectal bleeding, Taste change, Headache, Nosebleeds, Back pain, Dry skin, High blood pressure, Protein in urine, Inflammation of the nose | ![Avastin 400mg Injection](https://onemg.gumlet.io/l_watermark_346,w_480,h_480/a_ignore,w_480,h_480,c_fit,q_auto,f_auto/f5a26c491e4d48199ab116a69a969be3.jpg) | Roche Products India Pvt Ltd | 22 | 56 | 22 |
| Augmentin 625 Duo Tablet | Amoxycillin (500mg) + Clavulanic Acid (125mg) | Treatment of Bacterial infections | Vomiting, Nausea, Diarrhea, Mucocutaneous candidiasis | ![Augmentin 625 Duo Tablet](https://onemg.gumlet.io/l_watermark_346,w_480,h_480/a_ignore,w_480,h_480,c_fit,q_auto,f_auto/wy2y9bdipmh6rgkrj0zm.jpg) | Glaxo SmithKline Pharmaceuticals Ltd | 47 | 35 | 18 |
| Azithral 500 Tablet | Azithromycin (500mg) | Treatment of Bacterial infections | Nausea, Abdominal pain, Diarrhea | ![Azithral 500 Tablet](https://onemg.gumlet.io/l_watermark_346,w_480,h_480/a_ignore,w_480,h_480,c_fit,q_auto,f_auto/cropped/kqkouvaqejbyk47dvjfu.jpg) | Alembic Pharmaceuticals Ltd | 39 | 40 | 21 |

## Kurulum

### Gerekli Gereksinimler

- Flutter SDK
- Dart SDK

### Adımlar

1. Bu projeyi klonlayın:
   ```bash
   git clone https://github.com/username/MedTag.git
