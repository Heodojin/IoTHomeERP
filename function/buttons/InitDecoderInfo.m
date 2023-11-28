function BCI = InitDecoderInfo(BCI)
    BCI.decoderState = 'training';
    BCI.decoderInfo.iBlock = 0;
    BCI.decoderInfo.mode = '';
    % obj.decoderInfo.target = [];
    BCI.decoderInfo.IsConnected = false;
    BCI.decoderInfo.IsSetting = false;
    BCI.decoderInfo.whichCon = '';

    BCI.tcpip.address = '';
    BCI.tcpip.port = '';
end