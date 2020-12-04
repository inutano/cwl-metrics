cwlVersion: v1.0
class: Workflow
doc: Example workflow just to download two separated files by wget

inputs:
  metadata_url:
    type: string
    default: https://zenodo.org/record/3371848/files/metadata.txt
  classifier_url:
    type: string
    default: https://zenodo.org/record/3371848/files/gg-13-8-99-nb-classifier.qza

steps:
  download.metadata:
    run: https://raw.githubusercontent.com/pitagora-network/DAT2-cwl/develop/tool/wget/wget.cwl
    in:
      url: metadata_url
      use_remote_name:
        default: true
    out:
      - downloaded
  download.classifier:
    run: https://raw.githubusercontent.com/pitagora-network/DAT2-cwl/develop/tool/wget/wget.cwl
    in:
      url: classifier_url
      use_remote_name:
        default: true
    out:
      - downloaded

outputs:
  metadata:
    type: File
    outputSource: download.metadata/downloaded
  classifier:
    type: File
    outputSource: download.classifier/downloaded
