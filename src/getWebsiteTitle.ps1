# �����Ƃ��ăT�C�gURL���󂯎��
Param(
 [String]$WebSiteUrl
)

# �T�C�g�����擾
$WebSiteRes = Invoke-WebRequest -Uri $WebSiteUrl
# �T�C�g��񂩂�^�C�g�����擾
$WebSiteTitle = $WebSiteRes.ParsedHtml.getElementsByTagName('title')[0].innerText

# �擾�����^�C�g�����R���\�[���ɕ\��
Write-Host $WebSiteTitle
# �擾�����^�C�g�����e�L�X�g�t�@�C���ɏ����o��
Write-Output $WebSiteTitle > .\websitetitle.txt
