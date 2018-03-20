namespace: Demo
flow:
  name: createVM_1
  inputs:
    - host: 10.0.46.10
    - username: "Capa1\\1289-capa1user"
    - password: Automation123
    - datacenter: Capa1 Datacenter
    - image: Ubuntu
    - folder: Students/ReeseW
    - prefix_list: '1-,2-,3-'
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid: []
        publish:
          - uuid: '${"reese-"+uuid}'
        navigate:
          - SUCCESS: substring
    - substring:
        do:
          io.cloudslang.base.strings.substring:
            - origin_string: '${uuid}'
            - end_index: '13'
        publish:
          - id: '${new_string}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: FAILURE
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: '${host}'
            - user: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_source_identifier: name
            - vm_source: '${image}'
            - datacenter: '${datacenter}'
            - vm_name: '${id}'
            - vm_folder: '${folder}'
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: FAILURE
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: '${host}'
            - user: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_identifier: name
            - vm_name: '${id}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid:
        x: 100
        y: 250
      substring:
        x: 400
        y: 250
        navigate:
          7179f841-a838-1111-1cd2-77ad2efd23e0:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
      clone_vm:
        x: 713
        y: 242
        navigate:
          cf83eebb-125b-d7eb-980e-8be8bbb30b00:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
      power_on_vm:
        x: 966
        y: 243
        navigate:
          15d86aa0-58d1-c3fc-348b-a9570cd23122:
            targetId: ae5ca185-e45c-2657-35e0-0139421db917
            port: SUCCESS
          0c5b1d45-f1bc-42c2-f746-5aa4b2b9a7d4:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
    results:
      SUCCESS:
        ae5ca185-e45c-2657-35e0-0139421db917:
          x: 1203
          y: 226
      FAILURE:
        9830a567-5dbd-8459-6151-60810b8234a7:
          x: 595
          y: 472
