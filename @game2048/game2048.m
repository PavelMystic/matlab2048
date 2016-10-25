classdef game2048
  
  properties( SetAccess = private, GetAccess = private )
    
    handleFigure;
    handleBoxes;
    handleNumbers;
    gridSize = [4 4];
    
  end
  
  methods
    
    function obj = game2048()
      
      % create new figure
      obj.handleFigure = figure( ...
        'Color', 'cyan', ...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Name', 'game2048', ...
        'ToolBar', 'none', ...
        'Units', 'normalized', ...
        'KeyPressFcn', @game2048.myKeyPressFcn ...
      );
       
      % get grid size
      nBoxesRow = obj.gridSize(1);
      nBoxesCol = obj.gridSize(2);
      
      % create boxes in figure
      for iRow = 1:nBoxesRow
        
        for jCol = 1:nBoxesCol
          
          disp('new button')
          disp(iRow)
          disp(jCol)
          disp(nBoxesRow - iRow)
          disp(jCol - 1)
          
          obj.handleBoxes(iRow, jCol) = uicontrol(obj.handleFigure, ...
            'Style', 'pushbutton', ...
            'String', '', ...
            'Units', 'normalized', ...
            'Position', [(jCol - 1)/nBoxesRow (nBoxesRow - iRow)/nBoxesRow ...
              1/nBoxesRow 1/nBoxesCol], ...
            'Enable', 'off' ...
            );
          
        end
        
      end
      
      % set initially filled boxes
      firstFilledPosition = [randi(4), randi(4)];
      
      secondFilledPosition = [randi(4) randi(4)];
      
      while( firstFilledPosition(1) == secondFilledPosition(1) && firstFilledPosition(2) == secondFilledPosition(2) )
        
        secondFilledPosition = [randi(4) randi(4)];
        
      end
      
      % set empty numbers
      obj.handleNumbers = zeros(nBoxesRow, nBoxesCol);
      
      % fill graphics
      set(obj.handleBoxes(nBoxesRow - firstFilledPosition(1) + 1, firstFilledPosition(2)), 'String', '2');
      set(obj.handleBoxes(nBoxesRow - secondFilledPosition(1) + 1, secondFilledPosition(2)), 'String', '2');
      
      % fill array
      obj.handleNumbers(firstFilledPosition(1), firstFilledPosition(2)) = 2;
      obj.handleNumbers(secondFilledPosition(1), secondFilledPosition(2)) = 2;
      
      setappdata(obj.handleFigure, 'object', obj);
      
    end
    
    function numbers = getHandleNubers(obj)
      
      numbers = obj.handleNumbers;
      
    end
    
    function boxes = getHandleBoxes(obj)
      
      boxes = obj.handleBoxes;
      
    end
    
    function delete(obj)
      
      obj.handleFigure;
      close(obj.handleFigure)
      
    end
    
    
    
  end
  
  methods(Static)
    
    function myKeyPressFcn(src, event)
      
      keyPressed = event.Key;
      
      switch keyPressed
        
        case 'uparrow'
          
          disp('Youve pressed up-arrow');
          game2048.myUpArrowFcn(src);
          
        case 'downarrow'
          
          disp('Youve pressed down-arrow');
          game2048.myDownArrowFcn(src);
          
        case 'leftarrow'
          
          disp('Youve pressed left-arrow');
          game2048.myLeftArrowFcn(src);
          
        case 'rightarrow'
          
          disp('Youve pressed right-arrow');
          game2048.myRightArrowFcn(src)
          
        otherwise
            
          disp('Youve pressed some other key');
          
      end
      
    end
    
    function myLeftArrowFcn(src)
      
      myObj = getappdata(src, 'object');
      
      nBoxesRow = myObj.gridSize(1);
      nBoxesCol = myObj.gridSize(2);
      
      for iRow = 1:nBoxesRow
        
        for jCol = 2:nBoxesCol
          
          % get value
          currentValue = myObj.handleNumbers(iRow, jCol);
          
          if( currentValue > 0 )
            
            disp('I found interesting value!');
          
            for iSubCol = jCol-1:-1:1
              
              boxValue = myObj.handleNumbers(iRow, iSubCol);
              
              if( boxValue < 1e-5 )
                
                if( (iSubCol - 1) < 1e-5 )
                  
                  % fill graphics
                  set(myObj.handleBoxes(nBoxesRow - iRow + 1, iSubCol), 'String', num2str(currentValue));
                  
                  % fill array
                  myObj.handleNumbers(iRow, iSubCol) = num2str(currentValue);
                  
                  % clear old value from graphics
                  set(myObj.handleBoxes(nBoxesRow - iRow + 1, jCol), 'String', '');
                  
                  % clear old value from array
                  myObj.handleNumbers(iRow, jCol) = 0;
                  
                else
                  
                  % go on
                  
                end
                
              elseif( boxValue > 0 )
                
                if( abs(boxValue - currentValue) < 1e-5 )
                  
                  % sum up those two guys in iRow, iSubCol
                  % and clear value on iRow, jCol
                  % fill graphics
                  set(myObj.handleBoxes(nBoxesRow - iRow + 1, iSubCol), 'String', num2str(2*currentValue));
                  
                  % fill array
                  myObj.handleNumbers(iRow, iSubCol) = num2str(2*currentValue);
                  
                  % clear old value from graphics
                  set(myObj.handleBoxes(nBoxesRow - iRow + 1, jCol), 'String', '');
                  
                  % clear old value from array
                  myObj.handleNumbers(iRow, jCol) = 0;
                  
                  
                else
                  
                  % first check if iSubCol + 1 === jCol
                  % then move currentValue at iRow, iSubCol
                  % and clear value on iRow, jCol (but beware of first line
                  % cos it can lead to moving and clearing in place so this
                  % value will diappear and it is bad!
                  if( abs(iSubCol + 1 - jCol) < 1e-5 )
                    
                    % do nothing, save yourself some effort cos you will
                    % stay where you are
                    
                  else
                    
                    % fill graphics
                    set(myObj.handleBoxes(nBoxesRow - iRow + 1, iSubCol), 'String', num2str(currentValue));
                    
                    % fill array
                    myObj.handleNumbers(iRow, iSubCol) = num2str(currentValue);
                    
                    % clear old value from graphics
                    set(myObj.handleBoxes(nBoxesRow - iRow + 1, jCol), 'String', '');
                    
                    % clear old value from array
                    myObj.handleNumbers(iRow, jCol) = 0;
                    
                  end
                  
                end
                
              end
              
            end

          end
          
        end
        
      end
      
      % this is boring game, lets add new box with value
      newFilledPosition = [randi(4), randi(4)];
      
      % be sure that this infinite loop stops eventually
      maxWhile = 1e3;
      currentWhile = 0;
      
      while(  myObj.handleNumbers(newFilledPosition(1)) > 0 && ...
              myObj.handleNumbers(newFilledPosition(2)) > 0 && ...
              currentWhile < maxWhile )
        
        newFilledPosition = [randi(4) randi(4)];
        currentWhile = currentWhile + 1;
        
      end
      
      % fill graphics
      set(myObj.handleBoxes(nBoxesRow - newFilledPosition(1) + 1, newFilledPosition(2)), 'String', '2');
      
      % fill array
      myObj.handleNumbers(newFilledPosition(1), newFilledPosition(2)) = 2;
      
      setappdata(myObj.handleFigure, 'object', myObj);
      
    end
    
    function myRightArrowFcn()
      
    end
    
    function myUpArrowFcn()
      
    end
    
    function myDownArrowFcn()
      
    end
    
  end
  
end

