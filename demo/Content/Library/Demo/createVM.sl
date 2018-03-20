namespace: Demo
flow:
  name: createVM
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
        parallel_loop:
          for: prefix in prefix_list
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
              - vm_name: '${prefix+id}'
              - vm_folder: '${folder}'
              - mark_as_template: 'false'
              - trust_all_roots: 'true'
              - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: FAILURE
    - power_on_vm:
        parallel_loop:
          for: prefix in prefix_list
          do:
            io.cloudslang.vmware.vcenter.power_on_vm:
              - host: '${host}'
              - user: '${username}'
              - password:
                  value: '${password}'
                  sensitive: true
              - vm_identifier: name
              - vm_name: '${prefix+id}'
              - trust_all_roots: 'true'
              - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: wait_for_vm_info
          - FAILURE: FAILURE
    - wait_for_vm_info:
        parallel_loop:
          for: prefix in prefix_list
          do:
            io.cloudslang.vmware.vcenter.util.wait_for_vm_info:
              - host: '${host}'
              - user: '${username}'
              - password:
                  value: '${password}'
                  sensitive: true
              - vm_identifier: name
              - vm_name: '${prefix+id}'
              - datacenter: '${datacenter}'
              - wait_guest: 'true'
              - trust_all_roots: 'true'
              - x_509_hostname_verifier: allow_all
        publish:
          - ip_list: '${str([str(x["ip"]) for x in branches_context])}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - ip_list: '${ip_list}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid:
        x: 59
        y: 196
      substring:
        x: 271
        y: 201
        navigate:
          7179f841-a838-1111-1cd2-77ad2efd23e0:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
      clone_vm:
        x: 476
        y: 203
        navigate:
          cf83eebb-125b-d7eb-980e-8be8bbb30b00:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
      power_on_vm:
        x: 684
        y: 200
        navigate:
          c37a24e6-d5eb-f7b5-14fa-bca3e89d793c:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
      wait_for_vm_info:
        x: 902
        y: 198
        navigate:
          5b4b20ae-c2ca-5a43-ef50-788aa488a6de:
            targetId: ae5ca185-e45c-2657-35e0-0139421db917
            port: SUCCESS
            vertices:
              - x: 975
                y: 228
          88a18479-5313-d913-3bf4-a1cb948f53f0:
            targetId: 9830a567-5dbd-8459-6151-60810b8234a7
            port: FAILURE
    results:
      SUCCESS:
        ae5ca185-e45c-2657-35e0-0139421db917:
          x: 1113
          y: 187
      FAILURE:
        9830a567-5dbd-8459-6151-60810b8234a7:
          x: 595
          y: 472
