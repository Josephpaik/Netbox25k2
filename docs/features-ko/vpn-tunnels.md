# 터널

NetBox는 네트워크 전체의 가상 종단 지점 간에 형성된 사설 터널을 모델링할 수 있습니다. 일반적인 터널 구현에는 GRE, IP-in-IP 및 IPSec이 포함됩니다. 터널은 두 개 이상의 장비 또는 가상 머신 인터페이스로 종단될 수 있습니다. 편리한 구성을 위해 터널을 사용자 정의 그룹에 할당할 수 있습니다.

```mermaid
flowchart TD
    Termination1[TunnelTermination]
    Termination2[TunnelTermination]
    Interface1[Interface]
    Interface2[Interface]
    Tunnel --> Termination1 & Termination2
    Termination1 --> Interface1
    Termination2 --> Interface2
    Interface1 --> Device
    Interface2 --> VirtualMachine

click Tunnel "../../models/vpn/tunnel/"
click TunnelTermination1 "../../models/vpn/tunneltermination/"
click TunnelTermination2 "../../models/vpn/tunneltermination/"
```

# IPSec 및 IKE

NetBox에는 IPSec 및 IKE 정책 모델링을 위한 강력한 지원이 포함되어 있습니다. 이들은 IPSec 터널에 대한 암호화 및 인증 매개변수를 정의하는 데 사용됩니다.

```mermaid
flowchart TD
    subgraph IKEProposals[Proposals]
    IKEProposal1[IKEProposal]
    IKEProposal2[IKEProposal]
    end
    subgraph IPSecProposals[Proposals]
    IPSecProposal1[IPSecProposal]
    IPSecProposal2[IPSecProposal]
    end
    IKEProposals --> IKEPolicy
    IPSecProposals --> IPSecPolicy
    IKEPolicy & IPSecPolicy--> IPSecProfile
    IPSecProfile --> Tunnel

click IKEProposal1 "../../models/vpn/ikeproposal/"
click IKEProposal2 "../../models/vpn/ikeproposal/"
click IKEPolicy "../../models/vpn/ikepolicy/"
click IPSecProposal1 "../../models/vpn/ipsecproposal/"
click IPSecProposal2 "../../models/vpn/ipsecproposal/"
click IPSecPolicy "../../models/vpn/ipsecpolicy/"
click IPSecProfile "../../models/vpn/ipsecprofile/"
click Tunnel "../../models/vpn/tunnel/"
```
